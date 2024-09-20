part of 'backend_bloc.dart';

@immutable
abstract class BackendEvent {}

class SearchFlightEvent extends BackendEvent {
  bool isRoundTrip;
  bool isbaggage;
  bool isdirrectFlight;
  String fromItemCodeName;
  String toItemCodeName;
  String departureDate;
  String returnDate;
  int adult;
  int children;
  int infant;
  String classSeat;

  SearchFlightEvent(
      this.isRoundTrip,
      this.isbaggage,
      this.isdirrectFlight,
      this.fromItemCodeName,
      this.toItemCodeName,
      this.departureDate,
      this.returnDate,
      this.adult,
      this.children,
      this.infant,
      this.classSeat);
}

class emptyEvent extends BackendEvent {
  emptyEvent();
}
