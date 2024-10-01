import 'package:flutter/material.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/textShow.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const Button({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth * 0.4,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Textshow(text: text),
      ),
    );
  }
}
