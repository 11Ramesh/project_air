import 'package:flutter/material.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/containerarrow.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

class FlightCardRound extends StatelessWidget {
  List<String?>? startTimes;
  List<String?>? startlocations;
  List<String?>? spentTimes;
  List<String?>? endTimes;
  List<String?>? endlocations;
  String? nonStop;
  String? adult;
  String? weight;
  String? price;
  int? j;
  bool? isdirectFlight;
  bool isbaggage;

  FlightCardRound({
    this.startTimes,
    this.startlocations,
    this.spentTimes,
    this.nonStop,
    this.endTimes,
    this.endlocations,
    this.adult,
    this.weight,
    this.price,
    this.j,
    this.isdirectFlight,
    required this.isbaggage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.blue.shade300.withOpacity(0.6),
              Colors.white,
            ],
            stops: const [0.05, 0.15],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Textshow(
              text: "Emirates",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            Height(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: ScreenUtil.screenWidth * 0.2,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        for (int i = 0; i < (j ?? 1); i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Textshow(
                                    text: startTimes?[i] ?? "10:00",
                                    fontSize: 16,
                                  ),
                                  Textshow(
                                    text: startlocations?[i] ?? "London",
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                              Arrow(Width: ScreenUtil.screenWidth * 0.1),
                              isdirectFlight == true
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Textshow(
                                          text: spentTimes?[i] ?? "3H 30m",
                                          fontSize: 15,
                                        ),
                                        Textshow(
                                          text: nonStop ?? "Non Stop",
                                          fontSize: 15,
                                        ),
                                      ],
                                    )
                                  : Textshow(
                                      text: spentTimes?[i] ?? "3H 30m",
                                      fontSize: 15,
                                    ),
                              Arrow(Width: ScreenUtil.screenWidth * 0.1),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Textshow(
                                    text: endTimes?[i] ?? "1:00",
                                    fontSize: 16,
                                  ),
                                  Textshow(
                                    text: endlocations?[i] ?? "Singapore",
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                              Height(height: 60)
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Textshow(text: adult ?? "Adult 1", fontSize: 15),
                IconButton(
                  icon: Icon(Icons.edit, size: 16),
                  onPressed: () {},
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                isbaggage == true
                    ? Icon(Icons.work, size: 16)
                    : Icon(Icons.work_off_rounded, size: 16),
                Width(width: 10),
                isbaggage == true
                    ? Textshow(text: '${weight} Kg' ?? "30 Kg", fontSize: 15)
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Textshow(
                  text: price ?? "EUR 236.07",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Textshow(
                    text: "View flight Details",
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Textshow(
                    text: "Book Now",
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
