import 'dart:async';
import 'package:flutter/material.dart';

import '../widget/time_wheel.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool _isFinished = false;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isFinished = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              _stopTimer();
              _isFinished = true;
            }
          }
        }
      });
    });
  }

  // This function will be called when the user presses the cancel button
  // Cancel the timer
  void _cancelTimer() {
    setState(() {
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _hours = 0;
      _minutes = 0;
    });
  }

  void _stopTimer({bool reset = true}) {
    if (reset) {
      _resetTimer();
    }
    setState(() {
      _timer?.cancel();
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Colors.blue,
                Colors.red,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTime(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 200,
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (value) {
                        setState(() {
                          _hours = value.toInt();
                        });
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
                        setState(() {
                          _minutes = value.toInt();
                        });
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
                        setState(() {
                          _seconds = value.toInt();
                        });
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
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // The start/pause button
                  // The text on the button changes based on the state (_isRunning)
                  ElevatedButton(
                    onPressed: () {
                      if (_isRunning) {
                        _stopTimer(reset: false);
                      } else {
                        _startTimer();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 40)),
                    child:
                        _isRunning ? const Text('Pause') : const Text('Start'),
                  ),
                  // The cancel button
                  ElevatedButton(
                    onPressed: _cancelTimer,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(150, 40)),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));

  Widget buildTime() {
    if (_isFinished) {
      return Icon(
        Icons.done,
        color: Colors.blue,
        size: 112,
      );
    } else {
      return Text(
        '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 80),
      );
    }
  }

  Widget buildButtons() {
    if (_isFinished) {
      return ElevatedButton(
            onPressed: () {
              
                _startTimer();
              
            },
            style: ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
            child: _isRunning ? const Text('Pause') : const Text('Start'),
          );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // The start/pause button
          // The text on the button changes based on the state (_isRunning)
          ElevatedButton(
            onPressed: () {
              if (_isRunning) {
                _stopTimer(reset: false);
              } else {
                _startTimer();
              }
            },
            style: ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
            child: _isRunning ? const Text('Pause') : const Text('Start'),
          ),
          // The cancel button
          ElevatedButton(
            onPressed: _cancelTimer,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, fixedSize: const Size(150, 40)),
            child: const Text('Cancel'),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       body: Center(
  //         child: Container(
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                   begin: Alignment.topRight,
  //                   end: Alignment.bottomLeft,
  //                   colors: [
  //                 Colors.blue,
  //                 Colors.red,
  //               ])),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               buildButtons(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  // Widget buildButtons() {
  //   // final isRunning = _timer == null ? false : _timer!.isActive;
  //   // final isCompleted =
  //   //     _remainingTime == _totalTimeInSeconds || _remainingTime == 0;
  //   return _isRunning
  //       ? Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             buildTime(),
  //             SizedBox(height: 15),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 ButtonWidget(
  //                   text: _isRunning ? 'PAUSE' : 'RESUME',
  //                   onClicked: () {
  //                     if (_isRunning) {
  //                       stopTimer(reset: false);
  //                     } else {
  //                       startTimer(reset: false);
  //                     }
  //                   },
  //                 ),
  //                 const SizedBox(
  //                   width: 12,
  //                 ),
  //                 ButtonWidget(
  //                   text: 'CANCEL',
  //                   onClicked: () {
  //                     stopTimer();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         )
  //       : Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ClockWheel(
  //               updateHour: _updateHour,
  //               updateMinute: _updateMinute,
  //               updateSecond: _updateSecond,
  //             ),
  //             SizedBox(height: 10),
  //             ButtonWidget(
  //                 text: 'Start',
  //                 color: Colors.black,
  //                 backgroundColor: Colors.white,
  //                 onClicked: () {
  //                   startTimer();
  //                 }),
  //           ],
  //         );
  // }

  // Widget buildTime() {
  //   if (_hours == 0 && _minutes == 0 && _seconds == 0) {
  //     return Icon(
  //       Icons.done,
  //       color: Colors.blue,
  //       size: 112,
  //     );
  //   } else {
  //     return Text(
  //       '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
  //       style: TextStyle(
  //           fontWeight: FontWeight.bold, color: Colors.white, fontSize: 80),
  //     );
  //   }
  // }

  // // Widget buildTimer() {
  // //   return SizedBox(
  // //     width: 200,
  // //     height: 200,
  // //     child: Stack(fit: StackFit.expand, children: [
  // //       CircularProgressIndicator(
  // //         value: 1 - _remainingTime / _totalTimeInSeconds,
  // //         valueColor: AlwaysStoppedAnimation(Colors.white),
  // //         strokeWidth: 12,
  // //         backgroundColor: Colors.blue,
  // //       ),
  // //       Center(
  // //         child: buildTime(),
  // //       ),
  // //     ]),
  // //   );
  // // }

  // void startTimer({bool reset = true}) {
  //   if (reset) {
  //     _resetTimer();
  //   }
  //   setState(() {
  //     _isRunning = true;
  //   });

  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_seconds > 0) {
  //         _seconds--;
  //       } else {
  //         if (_minutes > 0) {
  //           _minutes--;
  //           _seconds = 59;
  //         } else {
  //           if (_hours > 0) {
  //             _hours--;
  //             _minutes = 59;
  //             _seconds = 59;
  //           } else {
  //             stopTimer(reset: false);
  //           }
  //         }
  //       }
  //     });
  //   });
  // }

  // void stopTimer({bool reset = true}) {
  //   if (reset) {
  //     _resetTimer();
  //   }
  //   setState(() {
  //     _timer?.cancel();
  //     _isRunning = false;
  //   });
  // }

  // void _pauseTimer() {
  //   _timer?.cancel();
  // }

  // void _cancelTimer() {
  //   setState(() {
  //     _hours = 0;
  //     _minutes = 0;
  //     _seconds = 0;
  //   });
  //   _timer?.cancel();
  // }

  // void _resetTimer() {
  //   setState(() {
  //     _seconds = 0;
  //     _hours = 0;
  //     _minutes = 0;
  //   });
  // }
}
