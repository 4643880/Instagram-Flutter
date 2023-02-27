import 'dart:developer' as devtools show log;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_flutter/models/post_model.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/show_snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post
  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profileImage,
  }) async {
    String res = "Something Went Wrong";
    try {
      String dawnloadedPostUrl = await StorageMethods().uploadImageToStorage(
        childName: "posts",
        file: file,
        isPost: true,
      );

      res = "success";

      final postId = const Uuid().v1();

      Post _post = Post(
        uid: uid,
        username: username,
        profileImg: profileImage,
        postId: postId,
        postUrl: dawnloadedPostUrl,
        description: description,
        datePublished: DateTime.now(),
        likes: [],
      );

      if (res == "success") {
        await _firestore.collection("posts").doc(postId).set(_post.toJson());
      }
      return res;
    } catch (e) {
      devtools.log(e.toString());
      res = e.toString();
      return res;
    }
  }
}
