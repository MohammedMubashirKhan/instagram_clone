import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final dataPublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.postId,
    required this.description,
    required this.dataPublished,
    required this.postUrl,
    required this.profImage,
    required this.uid,
    required this.username,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "profImage": profImage,
        "postId": postId,
        "dataPublished": dataPublished,
        "postUrl": postUrl,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var sanpshot = (snap.data() as Map<String, dynamic>);
    return Post(
      postId: sanpshot["postId"],
      description: sanpshot["discription"],
      dataPublished: sanpshot["dataPublished"],
      postUrl: sanpshot["postUrl"],
      profImage: sanpshot["profImage"],
      uid: sanpshot["uid"],
      username: sanpshot["username"],
      likes: sanpshot["likes"],
    );
  }
}
