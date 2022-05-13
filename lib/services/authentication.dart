import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class BaseAuth {
  Future<bool> signIn(String email, String password);

  Future<bool> signUp(
      String email, String password, String Name, var filename , var imageTemporary);

  Future<User?> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool?> isEmailVerified();

  late String err;
}

class Auth implements BaseAuth {
  String err = "";

  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<bool> signIn(String email, String password) async {
    try {
      final authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      err = e.toString();
      if (e.code == 'network-request-failed') {
        err = "Check your internet connection and try again";
      } else if (e.code == 'wrong-password') {
        err = "Wrong-password, please check your password and try again";
      } else if (e.code == 'user-not-found') {
        err = 'user-not-found';
      } else if (e.code == 'invalid-email') {
        err = 'invalid-email';
      }
      return false;
    }
    return true;
  }

  Future<bool> signUp(
      String email, String password, String Name, var filename , var imageTemporary) async {
    var imageurl;
    var id;
      try {
        final authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((result) {
          result.user!.updateDisplayName(Name);
          id = result.user?.uid;
        });
        if (filename != null){
          try {
            var ref = FirebaseStorage.instance.ref('Images')
                .child('Users')
                .child('$id')
                .child('$filename');
            await ref.putFile(imageTemporary!);
            imageurl = await ref.getDownloadURL();
          } on FirebaseAuthException catch (e) {
            print('asdasd');
            print(e.toString());
          }
      }
        else {
          imageurl = 'https://firebasestorage.googleapis.com/v0/b/flutter-maps-345318.appspot.com/o/Images%2FUsers%2FPlace_holder%2Fplace_holder.jpg?alt=media&token=6a90fef2-9e24-4874-a740-0c34fab2c9bf';
        }

        await FirebaseFirestore.instance.collection("users").doc(id).set(
            {
              "username": Name,
              "Email": email,
              "photourl": imageurl,
            });

      } on FirebaseAuthException catch (e) {
        print(e.toString());
        err = e.toString();
        if (e.code == 'weak-password') {
          err = "weak password";
          return false;
        } else if (e.code == "email-already-in-use") {
          err = "email-already-in-use";
          return false;
        }
      }
    return true;
  }

  Future<User?> getCurrentUser() async {
    final authResult = await FirebaseAuth.instance.currentUser;
    return authResult;
  }

  Future<void> signOut() async {
    final authResult = await FirebaseAuth.instance.signOut();
    return authResult;
  }

  Future<void> sendEmailVerification() async {
    final authResult = await FirebaseAuth.instance.currentUser;
    authResult?.sendEmailVerification();
  }

  Future<bool?> isEmailVerified() async {
    final authResult = await FirebaseAuth.instance.currentUser;
    return authResult?.emailVerified;
  }

  void _showAlertDialog(String message) async {
    buildPostFooter(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
