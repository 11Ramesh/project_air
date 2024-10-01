part of 'backend_bloc.dart';

@immutable
abstract class BackendState {}

final class BackendInitial extends BackendState {}

class SentDataState extends BackendState {
  List<Map<String, String>> sentData;

  SentDataState({required this.sentData});
}

class SentDataRoundState extends BackendState {
  List<Map<String, dynamic>> sentDataRound;
  bool isRoundTrip;
  bool isbaggage;
  bool isdirrectFlight;
  String fromItemCodeName;
  String toItemCodeName;
  String classSeat;
  List detailsforBooking;

  SentDataRoundState(
      {required this.sentDataRound,
      required this.isRoundTrip,
      required this.isbaggage,
      required this.isdirrectFlight,
      required this.fromItemCodeName,
      required this.toItemCodeName,
      required this.classSeat,
      required this.detailsforBooking});
}

class NoDataState extends BackendState {
  NoDataState();
}

class ErorrState extends BackendState {
  ErorrState();
}

class LoadingState extends BackendState {
  LoadingState();
}

class OrderFlightState extends BackendState {
  Map<String, dynamic> orderFlightData;
  String orderFlightID;

  OrderFlightState({
    required this.orderFlightID,
    required this.orderFlightData,
  });
}
