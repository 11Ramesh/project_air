import 'package:flutter/material.dart';
import 'package:project_air/widgets/textShow.dart';

class Tokenexpired extends StatelessWidget {
  const Tokenexpired({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Textshow(
          text: "Your Token Expired",
          fontSize: 40,
          fontWeight: FontWeight.bold),
    );
  }
}
