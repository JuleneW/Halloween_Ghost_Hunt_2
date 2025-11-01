import 'package:flutter/material.dart';
// import 'package:ghost_hunt/screens/home_screen.dart';
// import 'package:ghost_hunt/screens/list_screen.dart';
// import 'package:ghost_hunt/widgets/api_test_widget.dart';
// import 'package:ghost_hunt/widgets/ghost_card.dart';
// import 'package:ghost_hunt/widgets/ghost_list_widget.dart';
// import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/screens/login_screen.dart';
// import 'package:ghost_hunt/screens/test_screen.dart';
// import 'package:ghost_hunt/screens/unity_screen.dart';

void main() {
  runApp(const GhostHuntApp());
}

class GhostHuntApp extends StatelessWidget {
  const GhostHuntApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghost Hunt',
      // home: PlayerListPage(),
      home: LoginScreen(),
      // home: HomeScreen(),
      // home: ListScreen(),
      // home: GhostCard(),
      // home: GhostListWidget(),
      // home: UnityScreen(
      // ghostType: GhostType(
      //   id: '1',
      //   spawnLocations: [
      //   ],
      //   ),
      // ),
    );
  }
}
