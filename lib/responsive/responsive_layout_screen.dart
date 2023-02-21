import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/dimentions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraints) {
        if (contraints.maxWidth > webScreenSize) {
          // Web Screen
          return webScreenLayout;
        } else {
          return mobileScreenLayout;
        }
      },
    );
  }
}
