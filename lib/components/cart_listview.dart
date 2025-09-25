import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;
  const MyWidget({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      height: 75,
    );
  }
}
