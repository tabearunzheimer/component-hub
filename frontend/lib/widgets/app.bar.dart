import 'package:flutter/material.dart';

class CustomAppBar {
  AppBar appBar;

  CustomAppBar(BuildContext context, String title, TabBar? tabBar)
      : appBar = AppBar(
          title: Text(title),
          bottom: tabBar,
        );
}
