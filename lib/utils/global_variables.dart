import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

const dashboardScreenItems = [
  Center(child: Text("Feed")),
  Center(child: Text("Search")),
  AddPostScreen(),
  Center(child: Text("favorite")),
  Center(child: Text("profile")),
];
