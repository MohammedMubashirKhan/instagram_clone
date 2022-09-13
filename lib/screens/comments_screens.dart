import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/resources/firestore_methods.dart';
import 'package:instragran_clone/utils/utils.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final String uid;
  final String username;
  final String profileImg;

  CommentsScreen({
    Key? key,
    required this.username,
    required this.uid,
    required this.postId,
    required this.profileImg,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void postComment() async {
    String res = " Error";
    res = await FirestoreMethods().postComment(
        postID: widget.postId,
        comment: _commentController.text,
        username: widget.username,
        uid: widget.uid,
        profileImg: widget.profileImg);

    if (res == "success") {
      _commentController.text = "";
      showSnackBar("Comment is posted", context);
    } else {
      showSnackBar("Some erroe occure", context);
    }
  }

  likeComment(
    String commentId,
    List likes,
  ) async {
    String res = "Error";
    if (likes.contains(widget.uid)) {
      res = await FirestoreMethods().likeComment(
        commentId: commentId,
        postId: widget.postId,
        uid: widget.uid,
        toDislike: true,
      );
    } else {
      res = await FirestoreMethods().likeComment(
        commentId: commentId,
        postId: widget.postId,
        uid: widget.uid,
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            try {
              Navigator.of(context).pop();
            } catch (e) {
              print(e.toString());
            }
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postId)
            .collection("comments")
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Loading");
            return Center(
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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data!.docs[index].data()["profileImg"],
                        ),
                      ),
                      Text(
                        snapshot.data!.docs[index].data()["username"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                              snapshot.data!.docs[index].data()["comment"])),
                      IconButton(
                          onPressed: () {
                            likeComment(
                              snapshot.data!.docs[index].data()["commentId"],
                              snapshot.data!.docs[index].data()["likes"],
                            );
                          },
                          icon: snapshot.data!.docs[index]
                                      .data()["likes"]
                                      .contains(widget.uid) ??
                                  false
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(Icons.favorite_border_outlined))
                    ],
                  ),
                );
              },
            );
          }
          print("No Comments");
          return Text(
            "No Coment is posted yet!!!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1662751283309-829d4591be3a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60"),
            ),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
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
                  postComment();
                } else {
                  showSnackBar("Comments is empty", context);
                }
              },
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
