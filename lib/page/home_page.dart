import 'package:flutter/material.dart';
import 'package:timer/page/countdown.dart';
import 'package:timer/page/stop_watch.dart';
import 'package:timer/page/workout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${controller.index + 1}'),
          centerTitle: true,
          bottom: TabBar(controller: controller, tabs: [
            Tab(text: 'Timer'),
            Tab(text: 'Countdown'),
            Tab(
              text: 'Sound',
            )
          ]),
        ),
        body: TabBarView(controller: controller, children: [
          StopWatchPage(),
          Countdown(),
          Workout(),
        ]),
      );

  // List<String> items = [
  //   'Timer',
  //   'Countdown',
  //   'Loop',
  //   'Profile',
  //   'Something else',
  // ];

  // int current = 0;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.amberAccent,
  //     appBar: AppBar(),
  //     body: Container(
  //         margin: const EdgeInsets.all(5),
  //         width: double.infinity,
  //         height: double.infinity,
  //         child: Column(
  //           children: [
  //             SizedBox(
  //                 height: 60,
  //                 width: double.infinity,
  //                 child: ListView.builder(
  //                     physics: const BouncingScrollPhysics(),
  //                     itemCount: items.length,
  //                     scrollDirection: Axis.horizontal,
  //                     itemBuilder: (context, index) {
  //                       return Column(
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () => setState(() {
  //                               current = index;
  //                             }),
  //                             child: AnimatedContainer(
  //                               duration: const Duration(microseconds: 300),
  //                               margin: const EdgeInsets.all(5),
  //                               width: 80,
  //                               height: 45,
  //                               padding: const EdgeInsets.all(5),
  //                               decoration: BoxDecoration(
  //                                   color: current == index
  //                                       ? Colors.white70
  //                                       : Colors.white54,
  //                                   borderRadius: current == index
  //                                       ? BorderRadius.circular(15)
  //                                       : BorderRadius.circular(10),
  //                                   border: current == index
  //                                       ? Border.all(
  //                                           color: Colors.orange, width: 2)
  //                                       : null),
  //                               child: Center(
  //                                   child: Text(
  //                                 items[index],
  //                                 style: GoogleFonts.laila(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: current == index
  //                                         ? Colors.amber
  //                                         : Colors.grey),
  //                               )),
  //                             ),
  //                           ),
  //                           Visibility(
  //                               visible: current == index,
  //                               child: Container(
  //                                 width: 5,
  //                                 height: 5,
  //                                 decoration: const BoxDecoration(
  //                                     shape: BoxShape.circle),
  //                                 color: Colors.deepOrange,
  //                               ))
  //                         ],
  //                       );
  //                     }))
  //           ],
  //         )),
  //   );
  // }
}
