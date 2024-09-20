import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_air/const/color.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

class PassengerAndClass extends StatelessWidget {
  VoidCallback onTapPassenger;
  VoidCallback onTapClass;
  final int person;
  String classSeat;
  PassengerAndClass(
      {required this.onTapPassenger,
      required this.onTapClass,
      required this.person,
      required this.classSeat,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Pesenger tab
        InkWell(
          borderRadius: BorderRadius.circular(
            20,
          ),
          onTap: onTapPassenger,
          child: Container(
            padding: EdgeInsets.only(
                left: ScreenUtil.screenWidth * 0.05,
                top: ScreenUtil.screenWidth * 0.05),
            width: ScreenUtil.screenWidth * 0.42,
            height: ScreenUtil.screenWidth * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textshow(text: 'Passenger'),
                Height(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, size: 40.0),
                    Width(width: 20),
                    Textshow(
                      text: '$person Persons',
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        //Pesenger tab
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTapClass,
          child: Container(
            padding: EdgeInsets.only(
                left: ScreenUtil.screenWidth * 0.05,
                top: ScreenUtil.screenWidth * 0.05),
            width: ScreenUtil.screenWidth * 0.42,
            height: ScreenUtil.screenWidth * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textshow(text: 'Class seat'),
                Height(height: 10),
                Row(
                  children: [
                    Icon(Icons.airplane_ticket, size: 40.0),
                    Width(width: 20),
                    Textshow(
                      text: classSeat,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
