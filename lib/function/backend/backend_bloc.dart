import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:project_air/const/const.dart';
import 'package:project_air/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backend_event.dart';
part 'backend_state.dart';

class BackendBloc extends Bloc<BackendEvent, BackendState> {
  BackendBloc() : super(BackendInitial()) {
    on<BackendEvent>((event, emit) async {
      if (event is SearchFlightEvent) {
        //get token
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String token = sharedPreferences.getString('token').toString();

        var airlinesNameData = AirPortNameDataStore().airlinesNameData;

        bool isRoundTrip = event.isRoundTrip;
        bool isbaggage = event.isbaggage;
        bool isdirrectFlight = event.isdirrectFlight;
        String fromItemCodeName = event.fromItemCodeName;
        String toItemCodeName = event.toItemCodeName;
        String departureDate = event.departureDate;
        String returnDate = event.returnDate;
        int adult = event.adult;
        int children = event.children;
        int infant = event.infant;
        String classSeat = event.classSeat;

        String? spentTime;
        String? startTime;
        String? startlocation;
        String? endTime;
        String? endlocation;
        String? weight;
        String? price;
        String? startDate;
        String? endDate;
        String? airlinecode;

        List<Map<String, String>> sentData = [];
        List<Map<String, dynamic>> sentDataRound = [];
        List<Map<String, dynamic>> sentDataRoundFalseBaggage = [];
        List<Map<String, dynamic>> sentDataRoundTrueBaggage = [];
        List<Map<String, String>> segmentData = [];
        List detailsforBooking = [];

        try {
          var queryParams = {
            'originLocationCode': fromItemCodeName,
            'destinationLocationCode': toItemCodeName,
            'departureDate': departureDate,
            'adults': adult.toString(),
            'children': children.toString(),
            'infants': infant.toString(),
            'nonStop': isdirrectFlight.toString(),
            'max': '250',
            'travelClass': classSeat,
          };

          if (isRoundTrip) {
            queryParams['returnDate'] = returnDate;
          }
          String basesURL =
              "https://travel.api.amadeus.com/v2/shopping/flight-offers";

          var url =
              Uri.parse('$basesURL').replace(queryParameters: queryParams);

          var response = await http.get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          // print(response.statusCode);
          if (response.statusCode == 200) {
            var data = json.decode(response.body);

            if (!data['data'].isEmpty) {
              //round way
              for (var Element in data['data']) {
                // var itineraries = Element['itineraries'][0]['segments'];
                var itineraries = Element['itineraries'];
                segmentData = [];
                for (var segments in itineraries) {
                  var segment = segments['segments'];

                  for (var Element in segment) {
                    spentTime = Element['duration'];
                    spentTime = spentTime!.replaceAll("PT", "");
                    //
                    startTime = Element['departure']['at'];
                    DateTime dateTime = DateTime.parse(startTime!);
                    startTime = DateFormat('HH:mm').format(dateTime);
                    startDate = Element['departure']['at'];
                    startDate = startDate!.substring(0, 10);
                    startlocation = Element['departure']['iataCode'];
                    //
                    endTime = Element['arrival']['at'];
                    DateTime dateTime1 = DateTime.parse(endTime!);
                    endTime = DateFormat('HH:mm').format(dateTime1);
                    endDate = Element['arrival']['at'];
                    endDate = endDate!.substring(0, 10);
                    endlocation = Element['arrival']['iataCode'];
                    //
                    String flightNumber =
                        Element['carrierCode'] + Element['number'];

                    //
                    Map<String, String> segmentDataMap = {
                      'spentTime': spentTime ?? '',
                      'startTime': startTime ?? '',
                      'startDate': startDate ?? '',
                      'startLocation': startlocation ?? '',
                      'endTime': endTime ?? '',
                      'endDate': endDate ?? '',
                      'endLocation': endlocation ?? '',
                      'flightNumber': flightNumber ?? '',
                    };

                    segmentData.add(segmentDataMap);
                  }
                }

                //

                airlinecode = Element['validatingAirlineCodes']?[0];
                String? airlineName = AirPortNameDataStore()
                        .airlineNameData[airlinecode]?['airlineName'] ??
                    'No Airline Name';

                //

                price = Element['price']['total'] +
                    " " +
                    Element['price']['currency'];

                weight = (Element['travelerPricings']?[0]
                                ['fareDetailsBySegment']?[0]
                            ['includedCheckedBags']?['weight']
                        ?.toString()) ??
                    '0';
                // Map<String, dynamic> dataMap = {
                //   'segmentData': segmentData,
                //   'price': price ?? '',
                //   'adult': adult.toString()
                // };

                // sentDataRound.add(dataMap);

                if (weight == "0") {
                  Map<String, dynamic> dataMap = {
                    'segmentData': segmentData,
                    'price': price ?? '',
                    'adult': adult.toString(),
                    'weight': weight,
                    'airlinecode': airlinecode,
                    'airlineName': airlineName
                  };

                  sentDataRoundFalseBaggage.add(dataMap);
                } else {
                  Map<String, dynamic> dataMap = {
                    'segmentData': segmentData,
                    'price': price ?? '',
                    'adult': adult.toString(),
                    'weight': weight,
                    'airlinecode': airlinecode,
                    'airlineName': airlineName,
                  };
                  sentDataRoundTrueBaggage.add(dataMap);
                  detailsforBooking.add(Element);
                }
              }

              if (isbaggage) {
                emit(SentDataRoundState(
                    sentDataRound: sentDataRoundTrueBaggage,
                    isRoundTrip: isRoundTrip,
                    isbaggage: isbaggage,
                    isdirrectFlight: isdirrectFlight,
                    fromItemCodeName: fromItemCodeName,
                    toItemCodeName: toItemCodeName,
                    classSeat: classSeat,
                    detailsforBooking:detailsforBooking
                    ));
              } else {
                emit(SentDataRoundState(
                    sentDataRound: sentDataRoundFalseBaggage,
                    isRoundTrip: isRoundTrip,
                    isbaggage: isbaggage,
                    isdirrectFlight: isdirrectFlight,
                    fromItemCodeName: fromItemCodeName,
                    toItemCodeName: toItemCodeName,
                    classSeat: classSeat,
                    detailsforBooking:detailsforBooking
                    ));
              }
            } else {
              emit(NoDataState());
            }
          } else {
            print(response.statusCode);
            emit(ErorrState());
          }
        } catch (e) {
          emit(ErorrState());
        }
      } else if (event is emptyEvent) {
        emit(LoadingState());
      }
    });
  }
}
