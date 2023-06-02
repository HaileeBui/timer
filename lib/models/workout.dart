import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:timer/models/hiit.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:sound_mode/sound_mode.dart';

AudioPlayer player = AudioPlayer();

enum WorkoutState {
  initial,
  starting,
  exercising,
  repResting,
  setResting,
  finished
}

class Workout {
  Hiit _hiit;
  late Timer _timer;

  String countdownSound =
      "https://www.soundjay.com/household/sounds/creaking-floor-1.mp3";
  String restSound = "https://www.soundjay.com/clock/sounds/crank-1.mp3";
  String endSound = "https://www.soundjay.com/clock/sounds/crank-1.mp3";
  String startSound = "https://www.soundjay.com/clock/sounds/crank-1.mp3";

  Function _onStateChanged;
  WorkoutState _step = WorkoutState.initial;

  late Duration _timeRemaining;
  Duration _totalTimeElapsed = Duration(seconds: 0);

  int _rep = 0;
  int _set = 0;

  Workout(this._hiit, this._onStateChanged);

  // Getters
  get hiit => _hiit;
  get rep => _rep;
  get set => _set;
  get step => _step;
  get timeRemaining => _timeRemaining;
  get totalTimeElapsed => _totalTimeElapsed;
  get isActive => _timer.isActive;

  get timeRemainingSeconds => _timeRemaining.inSeconds;
  get timeElapsedSeconds => _totalTimeElapsed.inSeconds;
  get repDuration => _hiit.repDuration.inSeconds;
  get repRestTime => _hiit.repRest.inSeconds;
  get totalReps => _hiit.reps;
  get totalSets => _hiit.sets;
  get setRestTime => _hiit.setRest.inSeconds;
  get initialTimeSeconds => _hiit.initialTime.inSeconds;

  percentage() {
    if (_timer.isActive || !_timer.isActive) {
      if (_step == WorkoutState.starting) {
        return 1 - (timeRemainingSeconds / initialTimeSeconds);
      } else if (_step == WorkoutState.exercising) {
        return 1 - (timeRemainingSeconds / repDuration);
      } else if (_step == WorkoutState.repResting) {
        return 1 - (timeRemainingSeconds / repRestTime);
      } else if (_step == WorkoutState.setResting) {
        return 1 - (timeRemainingSeconds / setRestTime);
      } else {
        return 1.0;
      }
    }
  }

  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTimeElapsed += Duration(seconds: 1);
    }
    if (_timeRemaining.inSeconds == 1) {
      _nextStep();
    } else {
      _timeRemaining -= Duration(seconds: 1);
      // Play a countdown before the workout starts
      //if (_timeRemaining.inSeconds <= 3 && _step == WorkoutState.starting) {

      // Play a countdown the last 3 seconds of the current stage
      if (_timeRemaining.inSeconds <= 3) {
        _playSound(countdownSound);
      }
    }
    _onStateChanged();
  }

  start() {
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;

      if (_hiit.initialTime.inSeconds == 0) {
        _nextStep();
      } else {
        _timeRemaining = _hiit.initialTime;
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChanged();
  }

  pause() {
    _timer.cancel();
    _onStateChanged();
  }

  stop() {
    _timer.cancel();
    _step = WorkoutState.finished;
    _timeRemaining = Duration(seconds: 0);
  }

  dispose() {
    _timer.cancel();
  }

  _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (rep == _hiit.reps) {
        if (set == _hiit.sets) {
          _finish();
        } else {
          _startSetRest();
        }
      } else {
        _startRepRest();
      }
    } else if (_step == WorkoutState.repResting) {
      _startRep();
    } else if (_step == WorkoutState.starting ||
        _step == WorkoutState.setResting) {
      _startSet();
    }
  }

  // Starts the current rep by increasing the rep counter, setting the current
  // workout state to exercising, and time remaining to the current work time
  _startRep() {
    _rep++;
    _step = WorkoutState.exercising;
    _timeRemaining = _hiit.repDuration;
    _playSound(startSound);
  }

  // Starts the timer for the rep rest by setting the current workout state to
  // rep resting and once the time left in rep rest reaches 0, moves on to the
  // next step of the workout
  _startRepRest() {
    _step = WorkoutState.repResting;
    // If the time remaining in the rep rest is 0, move on to the next step
    if (_hiit.repRest.inSeconds == 0) {
      _nextStep();
      return;
    }
    _playSound(restSound);
    _timeRemaining = _hiit.repRest;
  }

  // Starts the current set by increasing the set counter, setting the rep to
  // 1 since it's the first rep in the set, setting the current workout state
  // to exercising, and time remaining to the current work time
  _startSet() {
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeRemaining = _hiit.repDuration;
    _playSound(startSound);
  }

  _startSetRest() {
    _step = WorkoutState.setResting;
    // If the time remaining in the rep rest is 0, move on to the next step
    if (_hiit.setRest.inSeconds == 0) {
      _nextStep();
      return;
    }
    _playSound(restSound);
    _timeRemaining = _hiit.setRest;
  }

  _finish() {
    // Cancel the timer
    _timer.cancel();
    //_showNotification();
    _step = WorkoutState.finished;
    _timeRemaining = Duration(seconds: 0);
    if (Platform.isAndroid) {
      _playSound(endSound);
    }
  }

  Future _playSound(String sound) async {
    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;
    if (Platform.isIOS) {
      // iOS doesn't push the message to flutter, so need to read twice
      await Future.delayed(Duration(milliseconds: 10), () async {
        SoundMode.ringerModeStatus;
      });
    }

    // If ringer is on, play a sound
    if (ringerStatus == RingerModeStatus.normal) {
      return await player.play(UrlSource(sound));
    }
    // If vibrate mode, send a vibration
    else if (ringerStatus == RingerModeStatus.vibrate) {
      return HapticFeedback.vibrate();
    }
    return;
  }

  // void _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "channelId", "channelName", "channelDescription",
  //       importance: Importance.max,
  //       priority: Priority.high,
  //   );

  //   var iosDetails =  IOSNotificationDetails();
  //   var generalNotificationDetails = new NotificationDetails(
  //       android: androidDetails, iOS: iosDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0, "HiitMe Interval Timer", "Workout Complete!", generalNotificationDetails
  //   );
  // }
}
