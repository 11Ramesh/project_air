import 'package:flutter/material.dart';
import 'package:project_air/widgets/width.dart';

class Arrow extends StatelessWidget {
  double Width;
  Arrow({super.key, required this.Width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          width: Width,
          child: Divider(
            thickness: 2,
            color: Colors.black,
          )),
    );
  }
}
