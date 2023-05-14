import 'package:flutter/material.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';

class MainJournal extends StatefulWidget {
  const MainJournal({super.key});
  static const String routeName = '/mainJournal';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MainJournal(),
    );
  }

  @override
  State<MainJournal> createState() => _MainJournalState();
}

class _MainJournalState extends State<MainJournal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Journal'),
    );
  }
}
