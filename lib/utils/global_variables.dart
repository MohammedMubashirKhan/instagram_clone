import 'package:flutter/material.dart';
import 'package:instragran_clone/screens/add_post_screen.dart';
import 'package:instragran_clone/screens/feed_screen.dart';
import 'package:instragran_clone/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPosrScreen(),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("This is Mobile"),
      Text("This is Favourate"),
    ],
  ),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("This is Mobile"),
      Text("This is Person"),
    ],
  ),
];
