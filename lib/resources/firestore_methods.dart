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

  // Like Post
  Future<void> likePost({
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }

  Future<void> postComment({
    required String postId,
    required String text,
    required String uid,
    required String name,
    required String profilePic,
  }) async {
    try {
      if (text.isNotEmpty) {
        final commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(
          {
            "profilePic": profilePic,
            "userName": name,
            "uid": uid,
            "text": text,
            "commentId": commentId,
            "datePublished": DateTime.now()
          },
        );
      } else {
        devtools.log("Text is empty...");
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }
}
