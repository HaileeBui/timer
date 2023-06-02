import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/page/home_page.dart';

void main() async {
  //var prefs = await SharedPreferences.getInstance();
  // runApp(MyApp(prefs: prefs));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // SharedPreferences prefs;
  // MyApp({required this.prefs});
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My timer demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: const Home(
          //prefs: prefs,
          ),
    );
  }
}
