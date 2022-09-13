import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/screens/comments_screens.dart';
import 'package:instragran_clone/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Screen"),
      ),
      body: PostCard(
        snap: {
          "likes": [],
          "postUrl":
              "https://firebasestorage.googleapis.com/v0/b/second-hand-book-exchang-1cf57.appspot.com/o/post%2FbjtN67cjEwR9SVpY2xv5m76eGz52%2Fdabb7cfc-98a2-4c5c-901d-0c6edb5a30a6?alt=media&token=f9e033b6-9a21-4591-864e-9b402dd5bb60",
          "description": "print",
          "dataPublished": Timestamp(1662627052, 964000000),
          "uid": "bjtN67cjEwR9SVpY2xv5m76eGz52",
          "profImage":
              "https://firebasestorage.googleapis.com/v0/b/second-hand-book-exchang-1cf57.appspot.com/o/profilePic%2FbjtN67cjEwR9SVpY2xv5m76eGz52?alt=media&token=d710dc59-8470-429a-8218-b87292d7e54e",
          "postId": "156c1211-085f-41c0-b94b-91912ad4b8e5",
          "username": "mmk",
        },
      ),
    );
  }
}
