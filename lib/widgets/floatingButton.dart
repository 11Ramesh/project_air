import 'package:flutter/material.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/textShow.dart';

class Floatingbuttons extends StatelessWidget {
  final VoidCallback onPressed;

  const Floatingbuttons({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth * 0.8,
      child: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: onPressed,
        child: Textshow(text: 'Search Flights', fontSize: 20),
      ),
    );
  }
}
