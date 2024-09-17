import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_air/const/color.dart';

class TripSelection extends StatefulWidget {
  final bool isRoundTrip;
  final Function(bool) onSelectionChanged;

  const TripSelection({
    Key? key,
    required this.isRoundTrip,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _TripSelectionState createState() => _TripSelectionState();
}

class _TripSelectionState extends State<TripSelection> {
  late bool isRoundTrip;

  @override
  void initState() {
    super.initState();
    isRoundTrip = widget.isRoundTrip;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            15,
          ),
          border: Border.all(width: 1, color: borderColor)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isRoundTrip = true;
                });
                widget.onSelectionChanged(isRoundTrip);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isRoundTrip ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Round Trip',
                  style: TextStyle(
                    color: isRoundTrip ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isRoundTrip = false;
                });
                widget.onSelectionChanged(isRoundTrip);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !isRoundTrip ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Text(
                  'One Way',
                  style: TextStyle(
                    color: !isRoundTrip ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
