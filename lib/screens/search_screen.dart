import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _userSearchController;
  bool isDisplayingUser = false;

  @override
  void initState() {
    _userSearchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _userSearchController,
          decoration: const InputDecoration(
            label: Text("Search for User"),
          ),
          onFieldSubmitted: (value) {
            // When field will be submit
            if (value.isNotEmpty) {
              setState(() {
                isDisplayingUser = true;
              });
            }
          },
        ),
      ),
      body: isDisplayingUser == true
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "username",
                    isGreaterThanOrEqualTo: _userSearchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          final eachUser = snapshot.data?.docs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(eachUser?.data()["photoUrl"]),
                            ),
                            title: Text(eachUser?.data()["username"]),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: blueColor,
                        ),
                      );
                    }
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    );
                  default:
                    return const Center(
                      child: RefreshProgressIndicator(),
                    );
                }
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return MasonryGridView.builder(
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              snapshot.data?.docs[index]["postUrl"],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: blueColor,
                        ),
                      );
                    }
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    );
                  default:
                    return const Center(
                      child: RefreshProgressIndicator(),
                    );
                }
              },
            ),
    );
  }
}
