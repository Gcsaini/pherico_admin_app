import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pherico_admin_app/config/firebase_constants.dart';
import 'package:pherico_admin_app/config/variables.dart';
import 'package:pherico_admin_app/resources/storage_methods.dart';
import 'package:pherico_admin_app/utils/pick_image.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          firstName.isNotEmpty ||
          lastName.isNotEmpty ||
          phone.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User user = model.User(
            email: email.toLowerCase(),
            username: email.split('@')[0],
            uid: cred.user!.uid,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            bio: '',
            followers: [],
            following: [],
            profile: defaultProfile,
            cover: defaultUserCover,
            pushToken: "");

        await _firebaseFirestore
            .collection(usersCollection)
            .doc(cred.user!.uid)
            .set(
              user.toJson(),
            );

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<String> updateUserProfileWithImage(Uint8List? file,
      String username, String firstName, String lastName) async {
    String res = 'An error occured';
    try {
      Uint8List image = await compressImage(file!);
      String imageUrl = await uploadImage(const Uuid().v1(), image, 'profiles');

      if (await userExists(username)) {
        res = 'username';
        return res;
      }
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'profile': imageUrl
      });
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<String> updateCover(Uint8List? file) async {
    String res = 'An error occured';
    try {
      Uint8List image = await compressImage(file!);
      String imageUrl = await uploadImage(const Uuid().v1(), image, 'covers');
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({'cover': imageUrl});
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<String> updateUserProfileWithoutImage(
      String username, String firstName, String lastName) async {
    String res = 'An error occured';
    try {
      if (await userExists(username)) {
        res = 'username';
        return res;
      }
      await firebaseFirestore
          .collection(usersCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
      });
      res = 'success';
      return res;
    } catch (error) {
      return res = error.toString();
    }
  }

  static Future<bool> userExists(String username) async =>
      (await firebaseFirestore
                  .collection("users")
                  .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid)
                  .where("username", isEqualTo: username)
                  .get())
              .docs
              .isEmpty
          ? false
          : true;

  Future<bool> emailExists(String email) async => (await firebaseFirestore
              .collection("users")
              .where('email', isEqualTo: email.toLowerCase())
              .get())
          .docs
          .isEmpty
      ? false
      : true;
}
