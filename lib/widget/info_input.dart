import 'package:flutter/material.dart';

class InfoInput extends StatefulWidget {
  final IconData icon; 

  const InfoInput({required this.icon});

  @override
  State<InfoInput> createState() => _InfoInputState();
}

class _InfoInputState extends State<InfoInput> {
  String input = '';
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
        print('View tapped!');
      },
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Row(
            children: [
              Icon(widget.icon),
              Text(
                input.isEmpty ? '' : 'Set time',
                style: TextStyle(color: Colors.orangeAccent, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
