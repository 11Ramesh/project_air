import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/const/localData.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/main.dart';
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

final List<int> passengerOptions = [1, 2, 3, 4];
final List<int> childrenOptions = [0, 1, 2, 3];
final List<int> infantsOptions = [0, 1, 2];

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
  int children = 0;
  int infant = 0;
  int person = 1;
  //api value
  String classSeat = 'ECONOMY';

  late BackendBloc backendBloc;

  var locationData = LocationDataStore().locationData;

  late int tokenExpiry;
  String? token = '';

  @override
  void initState() {
    backendBloc = BlocProvider.of<BackendBloc>(context);

    initializedDate();
    initializedsharedPreference();
    super.initState();
  }

  initializedsharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenExpiry = sharedPreferences.getInt('token_expiry') ?? 0;
    token = sharedPreferences.getString('token');
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
                      initializedDate();
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
                  person: person,
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
          if (token != null &&
              DateTime.now().millisecondsSinceEpoch < tokenExpiry) {
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
              children,
              infant,
              classSeat,
            ));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Booking()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Tokenexpired()));
          }
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

      dateLimitStart =
          '${DateTime.now().year}, ${DateTime.now().month}, ${DateTime.now().day}';
    });
  }

  void getDate(String text) async {
    if (isRoundTrip) {
      //rounded trip
      List<String> splitDateEnd = dateLimitEnd.split(', ');
      List<String> splitDateStart = dateLimitStart.split(', ');
      late DateTime? date;
      if (text == 'start') {
        date = await showDatePicker(
          context: context,
          initialDate: DateTime(
            int.parse(splitDateStart[0]),
            int.parse(splitDateStart[1]),
            int.parse(splitDateStart[2]),
          ),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
      } else {
        List<String> selectDateForReturnSegmentOnly = returnDate.split('-');
        date = await showDatePicker(
          context: context,
          initialDate: DateTime(
            int.parse(selectDateForReturnSegmentOnly[0]),
            int.parse(selectDateForReturnSegmentOnly[1]),
            int.parse(selectDateForReturnSegmentOnly[2]),
          ),
          firstDate: DateTime(
            int.parse(splitDateEnd[0]),
            int.parse(splitDateEnd[1]),
            int.parse(splitDateEnd[2]),
          ),
          lastDate: DateTime(2100),
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
            dateLimitStart = '${date.year}, ${date.month}, ${date.day}';

            ///
            //////
            ///
            // Convert departureDate and returnDate strings back to DateTime objects
            DateTime departure = DateTime.parse(departureDate);
            DateTime returnD = DateTime.parse(returnDate);

            if (returnD.isBefore(departure)) {
              returnDateviewOnly =
                  '${date.day} ${_getMonth(date.month)} ${date.year}';

              returnDate =
                  '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day}';
            }

            ///
            ///
            /////
            ///
            ///
          } else if (text == 'end') {
            returnDateviewOnly =
                '${date.day} ${_getMonth(date.month)} ${date.year}';

            returnDate =
                '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day}';
          }
        });
      }
      //oneway trip
    } else {
      List<String> splitDateStart = dateLimitEnd.split(', ');

      late DateTime? date;
      date = await showDatePicker(
        context: context,
        initialDate: DateTime(
          int.parse(splitDateStart[0]),
          int.parse(splitDateStart[1]),
          int.parse(splitDateStart[2]),
        ),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (date != null) {
        setState(() {
          _getMonth(date!.month);
          departureDateviewOnly =
              '${date.day} ${_getMonth(date.month)} ${date.year}';
          departureDate =
              '${date.year}-${date.month < 10 ? '0${date.month}' : date.month}-${date.day < 10 ? '0${date.day}' : date.day}';
          dateLimitEnd = '${date.year}, ${date.month}, ${date.day}';
        });
      }
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
    int selectedAdults = adult;
    int selectedChildren = children;
    int selectedInfants = infant;

    final selectedPassenger = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Passenger',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.zero, // Removes the default padding
          content: Padding(
            padding:
                const EdgeInsets.all(16.0), // Adds padding around the content
            child: SingleChildScrollView(
              // Ensures dialog content is scrollable
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Ensures the dialog takes only needed space
                children: [
                  // Dropdown for Adults
                  DropdownButtonFormField<int>(
                    value: selectedAdults,
                    decoration: InputDecoration(labelText: 'Number of Adults'),
                    items: passengerOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Adults'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedAdults = newValue!;
                    },
                  ),
                  SizedBox(height: 16),
                  // Dropdown for Children
                  DropdownButtonFormField<int>(
                    value: selectedChildren,
                    decoration:
                        InputDecoration(labelText: 'Number of Children'),
                    items: childrenOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Children'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedChildren = newValue!;
                    },
                  ),
                  SizedBox(height: 16),
                  // Dropdown for Infants
                  DropdownButtonFormField<int>(
                    value: selectedInfants,
                    decoration: InputDecoration(labelText: 'Number of Infants'),
                    items: infantsOptions.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value Infants'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      selectedInfants = newValue!;
                    },
                  ),
                  SizedBox(height: 32),
                  // Save Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        adult = selectedAdults;
                        children = selectedChildren;
                        infant = selectedInfants;

                        person = adult + children + infant;
                      });

                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
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
