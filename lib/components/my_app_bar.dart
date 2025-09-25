import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  const MyAppBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // your app bar implementation
    return AppBar(
      backgroundColor: index==2? Colors.grey[200]: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}