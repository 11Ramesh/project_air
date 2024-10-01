import 'package:flutter/material.dart';
import 'package:project_air/main.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/width.dart';

Future<void> showBoxFlightDetails(
    BuildContext context,
    List<Map<String, dynamic>> data,
    String airlineName,
    String classSeat,
    String weight) async {
  var locationData = LocationDataStore().locationData;

  int Stops = data.length - 1;
  List capituals = [];
  List durations = [];
  int totalDays = 0;
  Duration parseSpentTime(String spentTime) {
    try {
      int hours = 0;
      int minutes = 0;

      // Check if the input contains 'H' for hours
      if (spentTime.contains('H')) {
        final parts = spentTime.split('H');
        hours = int.parse(parts[0].trim());

        // If 'M' exists, parse minutes from the remaining part
        if (parts.length > 1 && parts[1].contains('M')) {
          minutes = int.parse(parts[1].replaceAll('M', '').trim());
        }
      }
      // If no 'H', check if it contains 'M' for minutes only
      else if (spentTime.contains('M')) {
        minutes = int.parse(spentTime.replaceAll('M', '').trim());
      } else {
        throw FormatException("Invalid format: Expected 'H' or 'M'");
      }

      // Return the duration based on parsed hours and minutes
      return Duration(hours: hours, minutes: minutes);
    } catch (e) {
      print("Error: $e");
      // Return a zero duration in case of error
      return Duration.zero;
    }
  }

  Duration totalDuration = Duration.zero;

  for (var element in data) {
    totalDuration += parseSpentTime(element['spentTime']);

    // Fixed missing variable declarations
    var filteredEntriesStart = locationData.entries
        .where((entry) => entry.key.startsWith(element['startLocation']))
        .toList()
        .first
        .value['city'];

    var filteredEntriesEnd = locationData.entries
        .where((entry) => entry.key.startsWith(element['endLocation']))
        .toList()
        .first
        .value['city'];

    capituals.add({
      'StartLocation': filteredEntriesStart,
      'EndLocation': filteredEntriesEnd
    });
  }

  for (var i = 0; i < data.length - 1; i++) {
    DateTime dateTime1 = DateTime.parse(
        '${data[i]['endDate']} ${data[i]['endTime']}'.replaceAll(' ', 'T'));
    DateTime dateTime2 = DateTime.parse(
        '${data[i + 1]['startDate']} ${data[i + 1]['startTime']}'
            .replaceAll(' ', 'T'));

    // Calculate the duration between the two DateTime objects
    Duration duration = dateTime2.difference(dateTime1);

    // Get the hours and minutes from the duration
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    totalDuration += Duration(hours: hours, minutes: minutes);
    durations.add({'days': days, 'hours': hours, 'minutes': minutes});
    totalDays += days;
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Textshow(
          text: 'Flight Details',
          fontSize: 15,
        ),
        content: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Textshow(
                  text: 'Outbound - $Stops Stop',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                Textshow(
                  text: (totalDays + totalDuration.inHours ~/ 24) > 0
                      ? '${totalDays + totalDuration.inHours ~/ 24} Days ${totalDuration.inHours % 24}:${totalDuration.inMinutes % 60}Hrs.'
                      : '${totalDuration.inHours % 24}:${totalDuration.inMinutes % 60}Hrs.',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.airplanemode_active),
                        Width(width: 10),
                        Textshow(
                          text:
                              "${airlineName} - ${data[index]['flightNumber']} - ${classSeat}",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        Height(height: 50),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Textshow(text: data[index]['startTime']),
                            Textshow(text: data[index]['startDate']),
                            Textshow(
                                text: capituals[index]['StartLocation']
                                            .toString()
                                            .length >
                                        10
                                    ? '${capituals[index]['StartLocation'].toString().substring(0, 7) + '...'}(${data[index]['startLocation']})'
                                    : '${capituals[index]['StartLocation']}(${data[index]['startLocation']})'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Textshow(text: data[index]['endTime']),
                            Textshow(text: data[index]['endDate']),
                            Textshow(
                                text: capituals[index]['EndLocation']
                                            .toString()
                                            .length >
                                        10
                                    ? '${capituals[index]['EndLocation'].toString().substring(0, 7) + '...'}(${data[index]['endLocation']})'
                                    : '${capituals[index]['EndLocation']}(${data[index]['endLocation']})')
                          ],
                        ),
                        Height(height: 10),
                        Row(
                          children: [
                            Icon(Icons.lock),
                            Width(width: 10),
                            Textshow(
                              text: "$weight Kg incl",
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Textshow(text: 'Connection Duration', fontSize: 15),
                          Textshow(
                              text: durations[index]['days'] == 0
                                  ? '${durations[index]['hours']}:${durations[index]['minutes']} Hrs.'
                                  : '${durations[index]['days']} Days ${durations[index]['hours']}:${durations[index]['minutes']} Hrs.',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
