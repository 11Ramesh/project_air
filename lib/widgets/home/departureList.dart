import 'package:flutter/material.dart';
import 'package:project_air/const/color.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

class Departurelist extends StatelessWidget {
  final VoidCallback onTapStart;
  final VoidCallback onTapEnd;
  final String departureDateviewOnly;
  final String returnDateviewOnly;
  final bool isRounded;
  const Departurelist(
      {required this.onTapStart,
      required this.onTapEnd,
      required this.departureDateviewOnly,
      required this.returnDateviewOnly,
      required this.isRounded,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 400,
      //height: isRounded ? 230 : 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          border: Border.all(color: borderColor)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //from tile
            ListTile(
              onTap: onTapStart,
              title: Textshow(
                text: 'Departure date',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 35.0),
                  Width(width: 20),
                  Textshow(
                    text: departureDateviewOnly,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              contentPadding: EdgeInsets.only(left: 20, right: 20, top: 5),
            ),
            isRounded ? Divider() : Container(),

            //to tile
            isRounded
                ? ListTile(
                    onTap: onTapEnd,
                    title: Textshow(
                      text: 'Return date',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.login, size: 35.0),
                        Width(width: 20),
                        Textshow(
                          text: returnDateviewOnly,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.only(left: 20, right: 20, top: 5),
                  )
                : const SizedBox(),
          ]),
    );
  }
}
