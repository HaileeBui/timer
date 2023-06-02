import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputAlertDialog extends StatefulWidget {
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  InputAlertDialog({
    required this.title,
    this.confirmWidget = const Text('OK',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
    this.cancelWidget = const Text('CANCEL',
        style: TextStyle(
            fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
  });

  @override
  State<StatefulWidget> createState() => _InputAlertDialogState();
}

class _InputAlertDialogState extends State<InputAlertDialog> {
  final inputController = TextEditingController();
  // Form key to keep track of the state
  final _formKey = GlobalKey<FormState>();
  String _errorString = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: TextFormField(
        controller: inputController,
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        cursorColor: Colors.deepPurpleAccent,
        key: _formKey,
        // When user input is changed, we need to make sure it's valid
        onChanged: (inputController) {
          validateName(inputController);
        },
        decoration: InputDecoration(
            hintText: "Timer Name",
            errorText: _errorString,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple))),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: widget.cancelWidget),
        TextButton(
            onPressed: () async {
              lastValidate(inputController.text);
            },
            child: widget.confirmWidget)
      ],
    );
  }

  void validateName(String inputController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (inputController.isEmpty) {
      setState(() {
        _errorString = "Please enter some text";
      });
    } else if (prefs.containsKey(inputController)) {
      setState(() {
        _errorString = "This timer name is already in use";
      });
    } else {
      setState(() {
        _errorString = '';
      });
    }
  }

  String lastValidate(String value) {
    if (_errorString.isEmpty) {
      Navigator.of(context).pop(value);
    }
    return '';
  }
}
