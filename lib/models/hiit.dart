import 'dart:convert';

Hiit get defaultHiit => Hiit(
    reps: 3,
    repDuration: Duration(seconds: 60),
    repRest: Duration(seconds: 30),
    sets: 2,
    setRest: Duration(seconds: 45),
    initialTime: Duration(seconds: 5));

class Hiit {
  int reps;
  Duration repDuration;
  Duration repRest;
  int sets;
  Duration setRest;
  Duration initialTime;

  Hiit({
    required this.reps,
    required this.repDuration,
    required this.repRest,
    required this.sets,
    required this.setRest,
    required this.initialTime,
  });

  Duration getTotalTime() {
    return (repDuration * reps * sets) +
        (repRest * sets * (reps - 1)) +
        (setRest * (sets - 1));
  }

  factory Hiit.fromJson(Map<String, dynamic> json) {
    return Hiit(
        reps: json['reps'],
        repDuration: Duration(seconds: json['repDuration']),
        repRest: Duration(seconds: json['repRest']),
        sets: json['sets'],
        setRest: Duration(seconds: json['setRest']),
        initialTime: Duration(seconds: json['initialTime']));
  }

  static Map<String, dynamic> toMap(Hiit hiit) => {
        'reps': hiit.reps,
        'repDuration': hiit.repDuration.inSeconds,
        'repRest': hiit.repRest.inSeconds,
        'sets': hiit.sets,
        'setRest': hiit.setRest.inSeconds,
        'initialTime': hiit.initialTime.inSeconds,
      };

  static String encode(List<Hiit> hiits) => json.encode(
        hiits.map<Map<String, dynamic>>((hiit) => Hiit.toMap(hiit)).toList(),
      );

  static List<Hiit> decode(String hiits) =>
      (json.decode(hiits) as List<dynamic>)
          .map<Hiit>((item) => Hiit.fromJson(item))
          .toList();
}
