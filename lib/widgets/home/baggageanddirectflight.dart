import 'package:flutter/material.dart';
import 'package:project_air/const/color.dart';
import 'package:project_air/widgets/height.dart';

class BaggageAndDirectFlight extends StatelessWidget {
  final bool directFlightValue;
  final bool baggageValue;
  final void Function(bool) onChangedDirectFlight;
  final void Function(bool) onChangedBaggage;

  const BaggageAndDirectFlight({
    required this.directFlightValue,
    required this.baggageValue,
    required this.onChangedDirectFlight,
    required this.onChangedBaggage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: Text('Direct flights only'),
            value: directFlightValue, // Updated here
            onChanged: onChangedDirectFlight,
          ),
          SwitchListTile(
            title: Text('With Baggage'),
            value: baggageValue, // Updated here
            onChanged: onChangedBaggage,
          ),
        ],
      ),
    );
  }
}
