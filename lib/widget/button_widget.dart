import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final Color backgroundColor;

  const ButtonWidget(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.backgroundColor = Colors.black,
      required this.onClicked});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      );
}
