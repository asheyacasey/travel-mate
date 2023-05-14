import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/screens/journal/journal_data.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';
import 'package:unicons/unicons.dart';

import 'journal.dart';

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
  void createNewJournal(BuildContext context) {
    //creating a new ID
    int id = Provider.of<JournalData>(context, listen: false)
        .getAllJournals()
        .length;

    Journal newJournal = Journal(id: id, text: '');
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color(0xFFB0DB2D);
    return ChangeNotifierProvider(
      create: (context) => JournalData(),
      builder: (context, child) => Consumer<JournalData>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          appBar: CustomAppBar(title: 'Journal'),
          floatingActionButton: FloatingActionButton(
            onPressed: () => createNewJournal(context),
            child: Icon(UniconsLine.plus),
            backgroundColor: color,
          ),
          body: Column(
            children: [
              CupertinoListSection.insetGrouped(
                children: List.generate(
                  value.getAllJournals().length,
                  (index) => CupertinoListTile(
                    title: Text(value.getAllJournals()[index].text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
