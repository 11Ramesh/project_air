import 'package:flutter/material.dart';
import 'package:project_air/main.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/textShow.dart';

class Tokenexpired extends StatelessWidget {
  const Tokenexpired({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Textshow(
              text: "Your Token Expired",
              fontSize: 40,
              fontWeight: FontWeight.bold),
          Button(
              text: "Go To Home",
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              })
        ],
      ),
    );
  }
}
