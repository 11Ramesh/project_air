import 'package:flutter/material.dart';
import 'package:project_air/const/color.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

// Define a model class for the list items

class DestinationList extends StatelessWidget {
  final VoidCallback onTapFrom;
  final VoidCallback onTapTo;
  final String fromContryName;
  final String fromCapitalName;
  final String fromItemCodeName;
  final String toContryName;
  final String toCapitalName;
  final String toItemCodeName;
  IconData icon;
  DestinationList(
      {required this.onTapFrom,
      required this.onTapTo,
      required this.icon,
      required this.fromContryName,
      required this.fromCapitalName,
      required this.fromItemCodeName,
      required this.toContryName,
      required this.toCapitalName,
      required this.toItemCodeName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 400,
      //height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          border: Border.all(color: borderColor)),
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //from tile
                ListTile(
                  horizontalTitleGap: ScreenUtil.screenWidth * 0.1,
                  onTap: onTapFrom,
                  leading: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Textshow(text: 'From', fontSize: 15),
                        const Icon(
                          Icons.flight_takeoff,
                          size: 30,
                        ),
                      ]),
                  title: Textshow(
                    text: fromContryName,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Textshow(
                    text: '${fromCapitalName} (${fromItemCodeName})',
                    fontSize: 13,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
                //devider
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                //to tile
                ListTile(
                  horizontalTitleGap: ScreenUtil.screenWidth * 0.1,
                  onTap: onTapTo,
                  leading: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Textshow(text: 'To', fontSize: 15),
                        const Icon(
                          Icons.flight_land,
                          size: 30,
                        ),
                      ]),
                  title: Textshow(
                    text: toContryName,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Textshow(
                    text: '${toCapitalName} (${toItemCodeName})',
                    fontSize: 13,
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
              ]),
          Positioned(
              // right: ScreenUtil.screenWidth * 0.05,
              // top: ScreenUtil.screenHeight * 0.111,
              right: 20,
              top: 75,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(91, 33, 149, 243),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                    border: Border.all(color: borderColor)),
                child: Icon(
                  icon,
                  size: 40,
                  color: Color.fromARGB(255, 54, 0, 248),
                ),
              )),
        ],
      ),
    );
  }
}
