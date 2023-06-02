import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/models/hiit.dart';
import 'package:timer/page/workout_screen.dart';
import 'package:timer/widget/input_dialog.dart';
import 'package:timer/widget/number_picker_modal.dart';
import 'package:timer/widget/time_picker_modal.dart';

class SetupScreen extends StatefulWidget {
  // SharedPreferences prefs;

  // SetupScreen({required this.prefs});
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  Hiit _hiit = defaultHiit;

  //Initialize shared preferences
  _retrieveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('hiitme');
    _hiit = json != null ? Hiit.fromJson(jsonDecode(json)) : defaultHiit;
    setState(() {});
  }

  @override
  initState() {
    _retrieveValues();

    // App rating prompt
    // WidgetsBinding.instance?.addPostFrameCallback((_) async {
    //   await _rateMyApp.init();
    //   if (mounted && _rateMyApp.shouldOpenDialog) {
    //     _rateMyApp.showRateDialog(context);
    //   }
    // });

    super.initState();
  }

  _onHiitChanged() {
    setState(() {});
    _saveHiit('hiitme');
  }

  _saveHiit(savedName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(savedName, json.encode(Hiit.toMap(_hiit)));
  }

  String _formatTime(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: <Color>[Colors.purple, Colors.indigo],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                )),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0,
                        MediaQuery.of(context).size.height * 0.05,
                        0,
                        MediaQuery.of(context).size.height * 0.08),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(_formatTime(_hiit.getTotalTime()),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.1,
                                    fontFamily: "Open Sans")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: FocusedMenuHolder(
                                        menuItems: <FocusedMenuItem>[
                                          FocusedMenuItem(
                                              title: Text("Start Timer",
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 16)),
                                              trailingIcon:
                                                  Icon(Icons.play_arrow),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WorkoutScreen(
                                                                hiit: _hiit)));
                                              }),
                                          FocusedMenuItem(
                                              title: Text("Save Timer",
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 16)),
                                              trailingIcon:
                                                  Icon(Icons.save_alt),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        InputAlertDialog(
                                                            // Set the initial duration
                                                            title: Text(
                                                                "Save Timer",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    PickerTextStyle()))).then(
                                                    (savedName) {
                                                  if (savedName == null) return;
                                                  _saveHiit(savedName);
                                                  _onHiitChanged();
                                                });
                                              }),
                                        ],
                                        menuWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        menuOffset: 20,
                                        onPressed: () {},
                                        child: SizedBox.fromSize(
                                          size: Size(56, 56),
                                          child: ClipOval(
                                            child: Material(
                                              color: Colors.amber,
                                              child: InkWell(
                                                splashColor: Colors.purple,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WorkoutScreen(
                                                                  hiit:
                                                                      _hiit)));
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.play_arrow),
                                                    Text("Start"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Starting time",
                                    style: TextStyle(
                                        fontFamily: "Raleway",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.w500)),
                                subtitle: Text(_formatTime(_hiit.initialTime),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                leading: Icon(Icons.start,
                                    size: MediaQuery.of(context).size.width *
                                        0.09),
                                onTap: () {
                                  showDialog<Duration>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TimePickerModal(
                                              // Set the initial duration
                                              initDuration: _hiit.initialTime,
                                              title: Text("Starting time",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        );
                                      }).then((delayTime) {
                                    // If null, don't do anything
                                    if (delayTime == null) return;
                                    // Update the work time to reflect user input
                                    _hiit.initialTime = delayTime;
                                    _onHiitChanged();
                                  });
                                },
                              ),
                              // Exercise Time
                              ListTile(
                                title:
                                    Text("Work Time", style: PickerTextStyle()),
                                subtitle: Text(_formatTime(_hiit.repDuration),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                leading: Icon(Icons.timer,
                                    size: MediaQuery.of(context).size.width *
                                        0.09),
                                onTap: () {
                                  showDialog<Duration>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TimePickerModal(
                                              // Set the initial duration
                                              initDuration: _hiit.repDuration,
                                              title: Text("Work Time",
                                                  textAlign: TextAlign.center,
                                                  style: PickerTextStyle())),
                                        );
                                      }).then((workTime) {
                                    // If null, don't do anything
                                    if (workTime == null) return;
                                    // Update the work time to reflect user input
                                    _hiit.repDuration = workTime;
                                    _onHiitChanged();
                                  });
                                },
                              ),
                              ListTile(
                                title:
                                    Text("Rest Time", style: PickerTextStyle()),
                                subtitle: Text(_formatTime(_hiit.repRest),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                leading: Icon(Icons.self_improvement,
                                    size: MediaQuery.of(context).size.width *
                                        0.09),
                                onTap: () {
                                  showDialog<Duration>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TimePickerModal(
                                              // Set the initial duration
                                              initDuration: _hiit.repRest,
                                              title: Text("Rest Time",
                                                  textAlign: TextAlign.center,
                                                  style: PickerTextStyle())),
                                        );
                                      }).then((repRestTime) {
                                    // If null, don't do anything
                                    if (repRestTime == null) return;
                                    // Update the rest time between each rep to reflect user input
                                    _hiit.repRest = repRestTime;
                                    _onHiitChanged();
                                  });
                                },
                              ),
                              // Reps
                              ListTile(
                                title: Text("Rounds", style: PickerTextStyle()),
                                subtitle: Text('${_hiit.reps}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                leading: Icon(Icons.repeat,
                                    size: MediaQuery.of(context).size.width *
                                        0.09),
                                onTap: () {
                                  showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: IntegerPicker(
                                              initialIntegerValue: _hiit.reps,
                                              title: Text("Rounds",
                                                  textAlign: TextAlign.center,
                                                  style: PickerTextStyle())),
                                        );
                                      }).then((reps) {
                                    // If null, don't do anything
                                    if (reps == null) return;
                                    // Update the number of reps to reflect user input
                                    _hiit.reps = reps;
                                    _onHiitChanged();
                                  });
                                },
                              ),
                              // Sets
                              ListTile(
                                title: Text("Total Workouts",
                                    style: PickerTextStyle()),
                                subtitle: Text('${_hiit.sets}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045)),
                                leading: Icon(Icons.fitness_center,
                                    size: MediaQuery.of(context).size.width *
                                        0.09),
                                onTap: () {
                                  showDialog<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: IntegerPicker(
                                            // Set the initial value
                                            initialIntegerValue: _hiit.sets,
                                            title: Text("Total Workouts",
                                                textAlign: TextAlign.center,
                                                style: PickerTextStyle()),
                                          ),
                                        );
                                      }).then((sets) {
                                    // If null, don't do anything
                                    if (sets == null) return;
                                    // If there is only 1 set in the workout, set the set rest time to 0
                                    if (sets == 1) {
                                      _hiit.setRest = Duration(seconds: 0);
                                    }
                                    // Update the number of sets to reflect user input
                                    _hiit.sets = sets;
                                    _onHiitChanged();
                                  });
                                },
                              ),
                              // Set Rest
                              ListTile(
                                  title: Text("Rest Between Workouts",
                                      style: PickerTextStyle()),
                                  subtitle: Text(_formatTime(_hiit.setRest),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045)),
                                  leading: Icon(Icons.self_improvement,
                                      size: MediaQuery.of(context).size.width *
                                          0.09),
                                  onTap: () {
                                    showDialog<Duration>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: TimePickerModal(
                                                // Set the initial duration
                                                initDuration: _hiit.setRest,
                                                title: Text(
                                                    "Rest Between Workouts",
                                                    textAlign: TextAlign.center,
                                                    style: PickerTextStyle())),
                                          );
                                        }).then((setRestTime) {
                                      // If null, don't do anything
                                      if (setRestTime == null) return;
                                      // Update the rest time after each set to reflect user input
                                      _hiit.setRest = setRestTime;
                                      _onHiitChanged();
                                    });
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ])),
          ],
        ),
      ),
    );
  }

  TextStyle PickerTextStyle() {
    return TextStyle(
        fontFamily: "Roboto",
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.05);
  }
}
