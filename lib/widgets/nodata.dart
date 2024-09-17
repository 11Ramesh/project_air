import 'package:flutter/material.dart';
import 'package:project_air/widgets/textShow.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Textshow(
          text: "No Data Found", fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}
