import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class IntegerPicker extends StatefulWidget {
  final int initialIntegerValue;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  const IntegerPicker({
    required this.initialIntegerValue,
    required this.title,
    this.confirmWidget = const Text('SAVE',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
    this.cancelWidget = const Text('CANCEL',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
  });

  @override
  State<IntegerPicker> createState() => _IntegerPickerState();
}

class _IntegerPickerState extends State<IntegerPicker> {
  int _initNumber = 0;

  @override
  void initState() {
    _initNumber = widget.initialIntegerValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: NumberPicker(
          value: _initNumber,
          minValue: 0,
          maxValue: 20,
          textStyle:
              TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          selectedTextStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              color: Colors.purple),
          // When the value changes, the state needs to be updated
          onChanged: (value) {
            setState(() {
              _initNumber = value;
            });
          }),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: widget.cancelWidget),
        // If the user clicks ok, the new value needs to be updated
        TextButton(onPressed: () => Navigator.of(context).pop(
            // Return the int value
            _initNumber), child: widget.confirmWidget)
      ],
    );
  }
}
