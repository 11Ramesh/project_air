import 'package:flutter/material.dart';
import 'package:project_air/widgets/textShow.dart';

class Checkconnection extends StatelessWidget {
  const Checkconnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Textshow(text: "No Internet Connection Please Try Again",fontSize: 35,fontWeight: FontWeight.bold),
    );
  }
}