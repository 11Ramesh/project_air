import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/screen/bookingscreen.dart';

import 'package:project_air/widgets/button.dart';
import 'package:project_air/widgets/floatingButton.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/home/baggageanddirectflight.dart';
import 'package:project_air/widgets/home/departureList.dart';
import 'package:project_air/widgets/home/destinationList.dart';
import 'package:project_air/widgets/home/pasengerandclass.dart';
import 'package:project_air/widgets/home/tougle.dart';
import 'package:project_air/widgets/textfield.dart';
import 'package:flutter/src/rendering/shifted_box.dart';
import 'package:http/http.dart' as http;
import 'package:project_air/widgets/tokenexpired.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  //api value
  bool isRoundTrip = true;
  //api value
  bool isbaggage = false;
  //api value
  bool isdirrectFlight = false;

  Map<String, Map<String, String>> locationData = {
    "DPS": {"city": "Dempasr Bali", "country": "Indonesia"},
    "DMK": {"city": "Don Mang", "country": "Thailand"},
    "XMN": {"city": "Xamen", "country": "China"},
    "SYD": {"city": "Sydney", "country": "Australia"},
    "BKK": {"city": "Bangkok", "country": "Thailand"},
  };

  // Starting default values
  String fromCapitalName = "Dempasr Bali";
  String fromContryName = "Indonesia";
  //api value
  String fromItemCodeName = 'DPS';

  String toCapitalName = "Don Mang";
  String toContryName = "Thailand";
  //api value
  String toItemCodeName = 'DMK';

  String monthName = '';
  //api value
  String departureDate = '';
  //api value
  String returnDate = '';
  String departureDateviewOnly = '';
  String returnDateviewOnly = '';
  String dateLimitEnd = '';
  String dateLimitStart = '';
  //api value
  int adult = 1;
  //api value
  String classSeat = 'BUSINESS';

  late BackendBloc backendBloc;
  

  @override
  void initState() {
    backendBloc = BlocProvider.of<BackendBloc>(context);
   
    initializedDate();
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil.screenWidth * 0.05,
              right: ScreenUtil.screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TripSelection(
                  isRoundTrip: isRoundTrip,
                  onSelectionChanged: (value) {
                    setState(() {
                      isRoundTrip = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DestinationList(
                  fromCapitalName: fromCapitalName,
                  fromContryName: fromContryName,
                  fromItemCodeName: fromItemCodeName,
                  toContryName: toContryName,
                  toCapitalName: toCapitalName,
                  toItemCodeName: toItemCodeName,
                  icon: isRoundTrip
                      ? Icons.swap_vert_outlined
                      : Icons.arrow_downward_rounded,
                  onTapFrom: () {
                    showBoxDestination(context, 'From');
                  },
                  onTapTo: () {
                    showBoxDestination(context, 'To');
                  },
                ),
                Height(height: 20),
                Departurelist(
                    isRounded: isRoundTrip,
                    departureDateviewOnly: departureDateviewOnly,
                    returnDateviewOnly: returnDateviewOnly,
                    onTapStart: () {
                      getDate('start');
                    },
                    onTapEnd: () {
                      getDate('end');
                    }),
                Height(height: 20),
                PassengerAndClass(
                  adult: adult,
                  classSeat: classSeat,
                  onTapPassenger: () {
                    showBoxPassenger(context);
                  },
                  onTapClass: () {
                    showBoxClassSeat(context);
                  },
                ),
                Height(height: 20),
                BaggageAndDirectFlight(
                    directFlightValue: isdirrectFlight,
                    baggageValue: isbaggage,
                    onChangedDirectFlight: (bool value) {
                      setState(() {
                        isdirrectFlight = value;
                      });
                    },
                    onChangedBaggage: (bool value) {
                      setState(() {
                        isbaggage = value;
                      });
                    }),
                Height(height: 100)
              ],
            ),
          ),
        ),
        floatingActionButton: Floatingbuttons(onPressed: () {
          // boloc////////////////////////////////////////////////////////////////////////////
          backendBloc.add(SearchFlightEvent(
              isRoundTrip,
              isbaggage,
              isdirrectFlight,
              fromItemCodeName,
              toItemCodeName,
              departureDate,
              returnDate,
              adult,
              classSeat));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Booking()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => X()));
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> showBoxDestination(BuildContext context, String text) async {
    String selectedCapital = '';
    String selectedCountry = '';
    String selectedCode = '';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            text,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Textfields(
                    prefixIcon: Icons.location_on,
                    controller: controller,
                    text: text,
                    onChanged: (value) {
                      setState(() {
                        final upperCode = value.toUpperCase();
                        if (locationData.containsKey(upperCode)) {
                          selectedCapital =
                              locationData[upperCode]?['city'] ?? '';
                          selectedCountry =
                              locationData[upperCode]?['country'] ?? '';
                          selectedCode = upperCode;
                        } else {
                          selectedCapital = '';
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  selectedCapital == ""
                      ? Center(child: Text("No Data Found"))
                      : ListTile(
                          onTap: () {
                            Navigator.pop(context, {
                              "capital": selectedCapital,
                              "country": selectedCountry,
                              "code": selectedCode,
                            });
                          },
                          title: Text("${selectedCapital} (${selectedCode})"),
                        ),
                ],
              );
            },
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        if (text == "From") {
          fromCapitalName = result["capital"]!;
          fromContryName = result["country"]!;
          fromItemCodeName = result["code"]!;
        } else if (text == "To") {
          toCapitalName = result["capital"]!;
          toContryName = result["country"]!;
          toItemCodeName = result["code"]!;
        }
      });
    }
  }

  void initializedDate() {
    setState(() {
      departureDateviewOnly =
          '${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}';
      returnDateviewOnly =
          '${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}';

      departureDate =
          '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}';
      returnDate =
          '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}';

      dateLimitEnd =
          '${DateTime.now().year}, ${DateTime.now().month}, ${DateTime.now().day}';

      dateLimitStart = '${2040}, ${01}, ${01}';
    });
  }

  void getDate(String text) async {
    List<String> splitDate = dateLimitEnd.split(', ');
    List<String> splitDateStart = dateLimitStart.split(', ');
    late DateTime? date;
    if (text == 'start') {
      date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(
          int.parse(splitDateStart[0]),
          int.parse(splitDateStart[1]),
          int.parse(splitDateStart[2]),
        ),
      );
    } else {
      date = await showDatePicker(
        context: context,
        initialDate: DateTime(
          int.parse(splitDate[0]),
          int.parse(splitDate[1]),
          int.parse(splitDate[2]),
        ),
        firstDate: DateTime(
          int.parse(splitDate[0]),
          int.parse(splitDate[1]),
          int.parse(splitDate[2]),
        ),
        lastDate: DateTime(2040),
      );
    }

    if (date != null) {
      setState(() {
        _getMonth(date!.month);
        if (text == 'start') {
          departureDateviewOnly =
              '${date.day} ${_getMonth(date.month)} ${date.year}';
          departureDate =
              '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day}';
          dateLimitEnd = '${date.year}, ${date.month}, ${date.day}';
        } else if (text == 'end') {
          returnDateviewOnly =
              '${date.day} ${_getMonth(date.month)} ${date.year}';
          returnDate =
              '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day}';
          dateLimitStart = '${date.year}, ${date.month}, ${date.day}';
        }
      });
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        monthName = 'January';
        break;
      case 2:
        monthName = 'February';
        break;
      case 3:
        monthName = 'March';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'August';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'October';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'December';
        break;
      default:
        monthName = 'Invalid month';
    }

    return monthName;
  }

  Future<void> showBoxPassenger(BuildContext context) async {
    final selectedPassenger = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Passenger',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite, // Adjust width to fit the content
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${index + 1} Adult'),
                  onTap: () {
                    Navigator.pop(context, '${index + 1}');
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedPassenger != null) {
      setState(() {
        adult = int.parse(selectedPassenger);
      });
    }
  }

  Future<void> showBoxClassSeat(BuildContext context) async {
    List seat = ['ECONOMY', 'PREMIUM_ECONOMY', 'BUSINESS', 'FIRST'];
    final selectedclassseat = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Passenger',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${seat[index]}'),
                  onTap: () {
                    Navigator.pop(context, '${seat[index]}');
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedclassseat != null) {
      setState(() {
        classSeat = selectedclassseat;
      });
    }
  }
}
