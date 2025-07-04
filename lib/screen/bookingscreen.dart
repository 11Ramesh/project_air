import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/const/size.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/screen/giveuserdetails.dart';
import 'package:project_air/screen/home.dart';
import 'package:project_air/screen/viewflightdetails.dart';
import 'package:project_air/widgets/appbar.dart';

import 'package:project_air/widgets/booking/cardroudtrip.dart';
import 'package:project_air/widgets/height.dart';
import 'package:project_air/widgets/nodata.dart';
import 'package:project_air/widgets/textShow.dart';
import 'package:project_air/widgets/tokenexpired.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late BackendBloc backendBloc;
  late int tokenExpiry;
  String? token = '';
  

  @override
  void initState() {
    iniitialize();
    super.initState();
  }

  iniitialize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    tokenExpiry = sharedPreferences.getInt('token_expiry') ?? 0;
    token = sharedPreferences.getString('token');
    backendBloc = BlocProvider.of<BackendBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackendBloc, BackendState>(
      builder: (context, state) {
        if (state is SentDataRoundState) {
          
          List<String> PersonNames = state.PersonNames;
          List<Map<String, dynamic>> sentDataRound = state.sentDataRound;
          bool isRoundTrip = state.isRoundTrip;
          bool isbaggage = state.isbaggage;
          bool isdirrectFlight = state.isdirrectFlight;
          String classSeat = state.classSeat;

          return WillPopScope(
            onWillPop: () async {
              backendBloc.add(emptyEvent());
              Navigator.pop(context);

              return false;
            },
            child: Scaffold(
              //backgroundColor: Color.fromARGB(80, 230, 230, 230),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    backendBloc.add(emptyEvent());
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),

                // toolbarHeight: 70,
                title: Row(
                  children: [
                    Textshow(
                      text: state.fromItemCodeName,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    Container(
                        width: ScreenUtil.screenWidth * 0.1,
                        child: Icon(Icons.arrow_forward)),
                    Textshow(
                      text: state.toItemCodeName,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),

                backgroundColor: Colors.white,

                //centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil.screenWidth * 0.025,
                    right: ScreenUtil.screenWidth * 0.025),
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 30,
                    automaticallyImplyLeading: false,
                    title: Textshow(
                      text: "Departing flights",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  body: ListView.builder(
                    itemCount: sentDataRound.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FlightCardRound(
                            isbaggage: isbaggage,
                            j: sentDataRound[index]['segmentData'].length,
                            startTimes: List<String?>.from(sentDataRound[index]
                                    ['segmentData']
                                .map((segment) => segment['startTime'])),
                            startDate: List<String?>.from(sentDataRound[index]
                                    ['segmentData']
                                .map((segment) => segment['startDate'])),
                            startlocations: List<String?>.from(
                                sentDataRound[index]['segmentData'].map(
                                    (segment) => segment['startLocation'])),
                            spentTimes: List<String?>.from(sentDataRound[index]
                                    ['segmentData']
                                .map((segment) => segment['spentTime'])),
                            nonStop: isdirrectFlight ? "Non Stop" : '',
                            endTimes: List<String?>.from(sentDataRound[index]
                                    ['segmentData']
                                .map((segment) => segment['endTime'])),
                            endDate: List<String?>.from(sentDataRound[index]
                                    ['segmentData']
                                .map((segment) => segment['endDate'])),
                            endlocations: List<String?>.from(
                                sentDataRound[index]['segmentData']
                                    .map((segment) => segment['endLocation'])),
                            adult: "${sentDataRound[index]['adult']} Adult",
                            weight: sentDataRound[index]['weight'],
                            price: sentDataRound[index]['price'],
                            isdirectFlight: isdirrectFlight,
                            airLineName: sentDataRound[index]['airlineName'],
                            image: sentDataRound[index]['airlinecode']
                                .toLowerCase(),
                            //image: 'tk'
                            fligtdetails: () {
                              showBoxFlightDetails(
                                  context,
                                  sentDataRound[index]['segmentData'],
                                  sentDataRound[index]['airlineName'],
                                  classSeat,
                                  sentDataRound[index]['weight']);
                            },
                            bookNow: () {
                              if (token != null &&
                                  DateTime.now().millisecondsSinceEpoch <
                                      tokenExpiry) {
                                Map<String, dynamic> data =
                                    state.detailsforBooking[index];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GivenUserDetails(
                                            pricingData: data, PersonNames: PersonNames)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tokenexpired()));
                              }
                            },
                          ),
                          Height(height: 10)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else if (state is NoDataState) {
          return Scaffold(body: NoData());
        } else if (state is ErorrState) {
          return Tokenexpired();
        } else if (state is LoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
