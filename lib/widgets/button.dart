import 'package:flutter/material.dart';
import 'package:project_air/const/size.dart'; // Assuming size constants are defined here
import 'package:project_air/widgets/textShow.dart'; // Assuming TextShow widget is defined here

class Button extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double width;

  const Button({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // Default background color
    this.foregroundColor = Colors.white, // Default foreground color
    this.height = 50.0, // Default height
    this.width = 10.0, // Default width
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Background color
          foregroundColor: foregroundColor, // Text/Icon color
        ),
        child: Textshow(
          text: text,
          fontSize: 20,
        ),
      ),
    );
  }
}
