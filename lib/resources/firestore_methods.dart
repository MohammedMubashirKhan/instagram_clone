import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instragran_clone/models/post.dart';
import 'package:instragran_clone/resources/storage_method.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload post into databse
  Future<String> uploadPost({
    required String uid,
    required String username,
    required String profileImg,
    required String description,
    required Uint8List file,
  }) async {
    String res = "some error occurred";
    try {
      String postDownloadUrl =
          await StorageMethod().uploadImageToStorage("post", file, true);

      String postId = const Uuid().v4();
      Post post = Post(
        postId: postId,
        description: description,
        dataPublished: DateTime.now(),
        postUrl: postDownloadUrl,
        profImage: profileImg,
        uid: uid,
        username: username,
        likes: [],
      );

      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Add comment to post
  Future<String> postComment({
    required String postID,
    required String comment,
    required String username,
    required String uid,
    required String profileImg,
  }) async {
    String res = "Error";
    String commentID = const Uuid().v1();
    try {
      await _firestore
          .collection("posts")
          .doc(postID)
          .collection("comments")
          .doc(commentID)
          .set({
        "username": username,
        "uid": uid,
        "comment": comment,
        "profileImg": profileImg,
        "commentId": commentID,
        "likes": [],
        "datePublished": DateTime.now(),
      });
      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<String> likeComment({
    required String commentId,
    required String postId,
    required String uid,
    bool toDislike = false,
  }) async {
    String res = "Erroe";
    try {
      if (toDislike) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<void> likePost({
    required String postId,
    required String uid,
    bool toDislike = false,
  }) async {
    try {
      if (toDislike) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  deletePost(String postId) async {
    String res = "Some error occur";
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
