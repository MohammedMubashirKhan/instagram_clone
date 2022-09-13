import 'package:flutter/material.dart';
import 'package:instragran_clone/providers/user_provider.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/screens/comments_screens.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snap["profImage"]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      snap["username"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shrinkWrap: true,
                        children: ["Delete"]
                            .map((e) => InkWell(
                                  onTap: () {},
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
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          // Image Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            child: Image.network(snap["postUrl"], fit: BoxFit.cover),
          ),

          // LIKE COMENT SECTION BOOKMARK
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    postId: snap["postId"],
                    uid: user.uid,
                    username: snap["username"],
                    profileImg: snap["profImage"],
                  ),
                )),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
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
                  "${snap["likes"].length} likes",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: primaryColor),
                    children: [
                      TextSpan(
                        text: snap["username"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " ${snap["description"]}",
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "View all 200 comments",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd().format(
                    snap["dataPublished"].toDate(),
                  ),
                  // snap["dataPublished"],
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
