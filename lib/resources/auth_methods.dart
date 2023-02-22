import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/show_error_dialog.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup User
  Future<String> signupUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        UserCredential userCredentials =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        devtools.log(userCredentials.user!.uid.toString());

        final dawnloadUrlOfProfilePic =
            await StorageMethods().uploadImageToStorage(
          childName: "Profile Pics",
          file: file,
          isPost: false,
        );

        // adding user in our database
        await _firestore.collection("users").doc(userCredentials.user!.uid).set(
          {
            "username": username,
            "uid": userCredentials.user!.uid,
            "email": email,
            "bio": bio,
            "followers": [],
            "following": [],
            "photoUrl": dawnloadUrlOfProfilePic,
          },
        );
        res = "success";
      }

      return res;
    } on FirebaseAuthException catch (e) {
      devtools.log(e.toString());
      if (e.code == 'weak-password') {
        devtools.log('The password provided is too weak.');
        await showErrorDialog(
            context, "Weak Password", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        devtools.log('The account already exists for that email.');
        await showErrorDialog(context, "Email Already in Use",
            "The account already exists for that email.");
      } else if (e.code == "invalid-email") {
        devtools.log("Invalid Email Address");
        await showErrorDialog(context, "Invalid Email Address",
            "Please Enter Correct Email Address it's Invalid");
      }
      res = e.code;
      return res;
    } catch (e) {
      res = e.toString();
      return res;
    }
  }
}
