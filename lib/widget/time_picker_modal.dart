import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimePickerModal extends StatefulWidget {
  final Duration initDuration;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  const TimePickerModal({
    required this.initDuration,
    required this.title,
    this.confirmWidget = const Text('SAVE',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
    this.cancelWidget = const Text('CANCEL',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
  });

  @override
  State<TimePickerModal> createState() => _TimePickerModalState();
}

class _TimePickerModalState extends State<TimePickerModal> {
  int _currentMin = 0;
  int _currentSec = 0;

  @override
  void initState() {
    _currentMin = widget.initDuration.inMinutes;
    _currentSec = widget.initDuration.inSeconds % Duration.secondsPerMinute;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NumberPicker(
              value: _currentMin,
              minValue: 0,
              maxValue: 30,
              textStyle:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              selectedTextStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.purple),
              // When the value changes, the state needs to be updated
              onChanged: (value) {
                setState(() {
                  _currentMin = value;
                });
              }),

          // Colon separator between minutes and seconds
          Text(":",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.purple)),

          // Number picker for seconds
          NumberPicker(
              value: _currentSec,
              minValue: 0,
              maxValue: 59,
              textStyle:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              selectedTextStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.purple),
              // When the value changes, the state needs to be updated
              onChanged: (value) {
                setState(() {
                  _currentSec = value;
                });
              }),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: widget.cancelWidget),
        TextButton(
            onPressed: () => Navigator.of(context)
                .pop(Duration(minutes: _currentMin, seconds: _currentSec)),
            child: widget.confirmWidget)
      ],
    );
    ;
  }
}
