import 'package:flutter/material.dart';

class Textfields extends StatelessWidget {
  final String text;
  final IconData prefixIcon;
  double? radius;
  Color? color;

  final void Function(String)? onChanged;
  TextEditingController controller;
  Textfields(
      {required this.text,
      required this.controller,
      required this.prefixIcon,
      this.radius,
      this.color,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        prefixIcon: Icon(prefixIcon),
        // suffixIcon: IconButton(onPressed: sufixOnPress, icon: Icon(sufixIcon)),
        iconColor: Colors.black,
        filled: true,
        hintText: text,
        hintStyle: TextStyle(),
        border: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none),
        fillColor: color,
      ),
    );
  }
}
