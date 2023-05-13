import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/container.dart';

class MainJournal extends StatelessWidget {
  static const String routeName = '/mainJournal';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MainJournal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text("Hi kapoy"),
      ),
    );
  }
}
