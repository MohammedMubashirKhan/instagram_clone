import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instragran_clone/models/user.dart' as model;
import 'package:instragran_clone/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get a one time view of user document in firebase
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    // print("!!!!!!!!!!!!!!!Data   ${snap.data()}    !!!!!!!!!!!!!!!!!!!");
    return model.User.fromSnap(snap);
  }

  // sign up user
  Future<List> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occure";
    List data = [];

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // user registration
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        // add profile photo to firebase Storage
        String photoUrl = await StorageMethod()
            .uploadImageToStorage("profilePic", file, false);

        // add user model
        model.User user = model.User(
            bio: bio,
            uid: cred.user!.uid,
            email: email,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            username: username,
            password: password);
        // add user to database
        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";
        data = [user, res];
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formated";
      } else {
        if (err.code == "weak-password") {
          res = "6 charecter password is required";
        }
      }
    } catch (err) {
      res = err.toString();
    }
    if (data.isEmpty) {
      return [0, res];
    } else {
      return data;
    }
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occure";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fiends";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "wrong-password") {
        res = "The password is invalid or the user does not have a password.";
      } else if (err.code == "user-not-found") {
        res =
            "There is no user record corresponding to this identifier. The user may have been deleted.";
      } else if (err.code == "invalid-email") {
        res = "Email adress is not valid.";
      } else if (err.code == "user-disabled") {
        res = "User is currently disabled.";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
