import 'package:flutter/material.dart';
import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

class FlightCard extends StatelessWidget {
  String? startTime;
  String? startlocation;
  String? spentTime;
  String? nonStop;
  String? endTime;
  String? endlocation;
  String? adult;
  String? weight;
  String? price;

  FlightCard(
      {this.startTime,
      this.startlocation,
      this.spentTime,
      this.nonStop,
      this.endTime,
      this.endlocation,
      this.adult,
      this.weight,
      this.price,
      super.key});

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
              Colors.blue.shade300
                  .withOpacity(0.6), // Blue at the bottom left corner
              Colors.white, // White for the rest of the card
            ],
            stops: const [
              0.05,
              0.15
            ], // Sharply restrict the spread to the bottom left corner
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
                  width: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Textshow(
                      text: startTime ?? "10:00",
                      fontSize: 18,
                    ),
                    Textshow(text: startlocation ?? "London"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Textshow(
                      text: spentTime ?? "3H 30m",
                      fontSize: 18,
                    ),
                    Textshow(text: nonStop ?? "Non Stop", fontSize: 15),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Textshow(
                      text: endTime ?? "1:00",
                      fontSize: 15,
                    ),
                    Textshow(text: endlocation ?? "Singapore", fontSize: 15),
                  ],
                )
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
                  width: 2, // Set the thickness of the line
                  height: 20, // Set the height of the line
                  color: Colors.black, // Set the color of the line
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20), // Add padding to the sides
                ),
                Icon(Icons.work, size: 16),
                Width(width: 10),
                Textshow(text: '${weight} Kg' ?? "30 Kg", fontSize: 15),
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
                      borderRadius: BorderRadius.circular(
                          10), // Set the border radius here
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
                      borderRadius: BorderRadius.circular(
                          10), // Set the border radius here
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
