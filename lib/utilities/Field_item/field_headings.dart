//Heading------------------------------------------------------heading
// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HeadLine extends StatelessWidget {
  String head;
  HeadLine({super.key, required this.head});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            head,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}