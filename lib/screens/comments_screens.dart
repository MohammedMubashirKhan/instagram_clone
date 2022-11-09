import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/providers/user_provider.dart';
import 'package:instragran_clone/resources/firestore_methods.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  final String username;
  final String profileImg;
  final bool withAppBar;

  const CommentsScreen(
      {Key? key,
      required this.username,
      required this.postId,
      required this.profileImg,
      this.withAppBar = true})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void postComment(String uid) async {
    String res = " Error";
    res = await FirestoreMethods().postComment(
        postID: widget.postId,
        comment: _commentController.text,
        username: widget.username,
        uid: uid,
        profileImg: widget.profileImg);

    if (res == "success") {
      _commentController.text = "";
      showSnackBar("Comment is posted", context);
    } else {
      showSnackBar("Some erroe occure", context);
    }
  }

  likeComment({
    required String commentId,
    required List likes,
    required String uid,
  }) async {
    String res = "Error";
    if (likes.contains(uid)) {
      res = await FirestoreMethods().likeComment(
        commentId: commentId,
        postId: widget.postId,
        toDislike: true,
        uid: uid,
      );
    } else {
      res = await FirestoreMethods().likeComment(
        commentId: commentId,
        postId: widget.postId,
        uid: uid,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: widget.withAppBar
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text("Comments"),
            )
          : AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postId)
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Loading");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isNotEmpty) {
            print("Comment is present");
            // print(
            //     (snapshot.data!.docs[0].data()["likes"]).contains(widget.uid));

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data!.docs[index].data()["profileImg"],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: snapshot.data!.docs[index]
                                        .data()["username"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "  ${snapshot.data!.docs[index].data()["comment"]}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Published date of comment
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat.yMMMd().format(
                                  snapshot.data!.docs[index]
                                      .data()["datePublished"]
                                      .toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () {
                                likeComment(
                                  commentId: snapshot.data!.docs[index]
                                      .data()["commentId"],
                                  likes: snapshot.data!.docs[index]
                                      .data()["likes"],
                                  uid: user.uid,
                                );
                              },
                              icon: snapshot.data!.docs[index]
                                          .data()["likes"]
                                          .contains(user.uid) ??
                                      false
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border_outlined)),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          print("No Comments");
          return const Text(
            "No Coment is posted yet!!!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: "Comment",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  postComment(user.uid);
                } else {
                  showSnackBar("Comments is empty", context);
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
