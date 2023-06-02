import 'package:flutter/material.dart';
import 'package:timer/widget/time_wheel.dart';

class ClockWheel extends StatelessWidget {
  final Function updateHour;
  final Function updateSecond;
  final Function updateMinute;
  
  const ClockWheel(
      {required this.updateHour,
      required this.updateMinute,
      required this.updateSecond});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 200,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) {
              updateHour(value);
            },
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.3,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 13,
              builder: (context, index) {
                return TimeWheel(
                  time: index,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 70,
          height: 200,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) {
              updateMinute(value);
            },
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.3,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 60,
              builder: (context, index) {
                return TimeWheel(
                  time: index,
                );
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: 70,
          height: 200,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) {
              updateSecond(value);
            },
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.3,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 60,
              builder: (context, index) {
                return TimeWheel(
                  time: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
