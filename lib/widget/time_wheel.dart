import 'package:flutter/material.dart';

class TimeWheel extends StatelessWidget {
  int time;

  TimeWheel({required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
            child: Text(time < 10 ? '0$time' : time.toString(),
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
