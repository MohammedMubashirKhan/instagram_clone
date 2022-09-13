import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String photoUrl;
  final String password;

  const User({
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.uid,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "password": password,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var sanpshot = (snap.data() as Map<String, dynamic>);
    return User(
      bio: sanpshot["bio"],
      email: sanpshot["email"],
      followers: sanpshot["followers"],
      following: sanpshot["following"],
      photoUrl: sanpshot["photoUrl"],
      uid: sanpshot["uid"],
      username: sanpshot["username"],
      password: sanpshot["password"],
    );
  }
}
