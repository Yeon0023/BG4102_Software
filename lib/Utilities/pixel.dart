import 'package:flutter/material.dart';

class MyPixel extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final color;

  const MyPixel({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            color: color,
          )),
    );
  }
}
