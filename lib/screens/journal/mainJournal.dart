import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/screens/journal/home_page_journal.dart';
import 'package:travel_mate/screens/journal/journal_data.dart';

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
    return ChangeNotifierProvider(
      create: (context) => JournalData(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: JournalHomePage(),
      ),
    );
  }
}
