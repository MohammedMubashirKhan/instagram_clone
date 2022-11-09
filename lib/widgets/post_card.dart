import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/resources/firestore_methods.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/screens/comments_screens.dart';
import 'package:instragran_clone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User? user;
  BoxFit isTapOnImage = BoxFit.cover;
  int commentLength = 0;
  void likePost({required String uid}) async {
    if (!widget.snap["likes"].contains(uid)) {
      FirestoreMethods().likePost(postId: widget.snap["postId"], uid: uid);
    } else {
      FirestoreMethods()
          .likePost(postId: widget.snap["postId"], uid: uid, toDislike: true);
    }
  }

  Future<int> getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      commentLength = snap.docs.length;
      // setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    return commentLength;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context, listen: true).getUser;

    return user != null
        ? Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(widget.snap["profImage"]),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.snap["username"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shrinkWrap: true,
                              children: ["Delete"]
                                  .map((e) => InkWell(
                                        onTap: () {
                                          FirestoreMethods().deletePost(
                                              widget.snap["postId"]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            // child: InkWell(
                            //   onTap: () {},
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Text("Delete"),
                            //   ),
                            // ),
                          ),
                        ),
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                // Image Section
                GestureDetector(
                  // onDoubleTap: () => likePost(uid: user!.uid),
                  onTap: () {
                    Navigator.push(context, PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Scaffold(
                          body: GestureDetector(
                            // onVerticalDragStart: (details) {
                            //   print(details.globalPosition);
                            // },
                            onVerticalDragDown: (details) {
                              Navigator.pop(context);
                            },
                            child: SafeArea(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(widget.snap["postUrl"]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Description: ",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.snap["description"],
                                            style: const TextStyle(
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ));
                  },
                  // onTapDown: (details) {
                  //   setState(() {
                  //     isTapOnImage = BoxFit.contain;
                  //   });
                  // },
                  // onTapUp: (details) {
                  //   setState(() {
                  //     isTapOnImage = BoxFit.cover;
                  //   });
                  // },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap["postUrl"],
                      fit: isTapOnImage,
                    ),
                  ),
                ),

                // LIKE COMENT SECTION BOOKMARK
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print(widget.snap["likes"]);
                        likePost(uid: user!.uid);
                      },
                      icon: widget.snap["likes"].contains(user!.uid)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                      // icon: Icon(Icons.favorite),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (context) => CommentsScreen(
                              postId: widget.snap["postId"],
                              username: widget.snap["username"],
                              profileImg: widget.snap["profImage"],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_outline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // DESCRIPTION ANDD NUMBEROF COMMENTS
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text(
                        "${widget.snap["likes"].length} likes",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.snap["username"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " ${widget.snap["description"]}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FutureBuilder(
                            // future: getComments(),
                            builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "View all comments",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 16,
                              ),
                            );
                          }
                          return Text(
                            "View all $commentLength comments",
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap["dataPublished"].toDate(),
                        ),
                        // snap["dataPublished"],
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          )
        : Container();
  }
}
