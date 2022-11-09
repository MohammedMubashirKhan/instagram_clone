import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/screens/add_post_screen.dart';
import 'package:instragran_clone/screens/feed_screen.dart';
import 'package:instragran_clone/screens/person_screen.dart';
import 'package:instragran_clone/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPosrScreen(),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text("This is Mobile"),
      Text("This is Favourate"),
    ],
  ),
  PersonScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
