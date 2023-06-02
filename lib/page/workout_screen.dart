import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:timer/models/hiit.dart';
import 'package:timer/models/workout.dart';
import 'package:wakelock/wakelock.dart';

String workoutStage(WorkoutState step) {
  switch (step) {
    case WorkoutState.starting:
      return "STARTING";
    case WorkoutState.exercising:
      return "EXERCISE";
    case WorkoutState.repResting:
      return "ROUND REST";
    case WorkoutState.setResting:
      return "WORKOUT REST";
    case WorkoutState.finished:
      return "FINISHED";
    default:
      return "";
  }
}

class WorkoutScreen extends StatefulWidget {
  final Hiit hiit;
  const WorkoutScreen({required this.hiit});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Workout _workout;
  @override
  void initState() {
    Wakelock.enable();
    _workout = Workout(widget.hiit, _onWorkoutChanged);
    _start();
    super.initState();
  }

  _onWorkoutChanged() {
    setState(() {});
  }

  _start() {
    _workout.start();
  }

  _pause() {
    _workout.pause();
  }

  @override
  void dispose() {
    _workout.dispose();
    Wakelock.disable();
    super.dispose();
  }

  _backgroundColour(ThemeData theme) {
    switch (_workout.step) {
      case WorkoutState.exercising:
        return Colors.lightGreen;
      case WorkoutState.repResting:
        return Colors.blueAccent;
      case WorkoutState.setResting:
        return Colors.pink;
      default:
        return theme;
    }
  }

  String _formatTime(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: _getDecoration(theme),
              padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.08,
                  20,
                  MediaQuery.of(context).size.height * 0.08),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(workoutStage(_workout.step),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontFamily: "Raleway",
                              color: Colors.white70))
                    ],
                  ),
                  Divider(
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white),
                  CircularPercentIndicator(
                    percent: _workout.percentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animateFromLastPercent: true,
                    radius: MediaQuery.of(context).size.height * 0.2,
                    lineWidth: MediaQuery.of(context).size.height * 0.02,
                    progressColor:
                        _workout.isActive ? Colors.white : Colors.white70,
                    backgroundColor: Colors.black12,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_formatTime(_workout.timeRemaining),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1,
                                fontFamily: "Open Sans",
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025),
                        Text("Time Elapsed",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center),
                        Text(_formatTime(_workout.totalTimeElapsed),
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                  Divider(
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white),
                  Table(
                      // Setting up the columns
                      columnWidths: {
                        0: FlexColumnWidth(0.5),
                        1: FlexColumnWidth(0.5)
                      },
                      // Setting up the rows
                      children: [
                        // First row - Contains the text
                        TableRow(children: [
                          // Set
                          TableCell(
                              child: Text("WORKOUT",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      color: Colors.white70),
                                  textAlign: TextAlign.center)),
                          // Rep
                          TableCell(
                              child: Text("ROUND",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      color: Colors.white70),
                                  textAlign: TextAlign.center))
                        ]),

                        // Second row - Contains the info
                        TableRow(children: [
                          // Set
                          TableCell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                Text('${_workout.set}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        color: Colors.white),
                                    textAlign: TextAlign.center),
                                Text('/${_workout.totalSets}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        color: Colors.white70),
                                    textAlign: TextAlign.center)
                              ])),
                          // Rep
                          TableCell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                Text('${_workout.rep}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        color: Colors.white),
                                    textAlign: TextAlign.right),
                                Text('/${_workout.totalReps}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        color: Colors.white70),
                                    textAlign: TextAlign.right)
                              ])),
                        ]),
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Expanded(child: _buttonBar())
                ],
              ),
            )
          ],
        )));
  }

  _getDecoration(ThemeData theme) {
    if (_workout.step == WorkoutState.initial ||
        _workout.step == WorkoutState.starting ||
        _workout.step == WorkoutState.finished) {
      return BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.purple, Colors.indigo],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight));
    } else {
      return BoxDecoration(color: _backgroundColour(theme));
    }
  }

  Widget _buttonBar() {
    // On finished, show a button to go back to main screen
    if (_workout.step == WorkoutState.finished) {
      return IconButton(
          padding: EdgeInsets.all(15),
          iconSize: MediaQuery.of(context).size.height * 0.12,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.home, color: Colors.white70));
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              iconSize: MediaQuery.of(context).size.height * 0.12,
              onPressed: () => {
                    _workout.dispose(),
                    Navigator.pop(context),
                  },
              icon: Icon(Icons.cancel, color: Colors.white70)),
          IconButton(
              iconSize: MediaQuery.of(context).size.height * 0.12,
              onPressed: _workout.isActive ? _pause : _start,
              icon: Icon(
                  _workout.isActive
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white70))
        ],
      );
    }
  }
}
