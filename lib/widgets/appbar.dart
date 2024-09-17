import 'package:flutter/material.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';

class Appbars extends StatelessWidget {
  bool isRoundTrip;
  Appbars({required this.isRoundTrip, super.key});

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(bottom: 2.0), // Adjust this value for spacing
          child: Row(
            children: [
              Textshow(text: 'text'),
              Container(
                  width: ScreenUtil.screenWidth * 0.1,
                  child: Icon(Icons.arrow_forward)),
              Textshow(text: 'text'),
            ],
          ),
        ),
        Row(
          children: [
            isRoundTrip
                ? Textshow(
                    text: 'Round Way Flight',
                    fontSize: 14,
                  )
                : Textshow(
                    text: 'One Way Flight',
                    fontSize: 14,
                  ),
            Text(' ()'),
            TextButton(onPressed: () {}, child: Text('Edit'))
          ],
        ),
      ],
    );
  }
}
