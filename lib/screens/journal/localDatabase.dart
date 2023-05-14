import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_mate/screens/journal/journal.dart';

class LocalDatabase {
  //reference the hive box
  final _mybox = Hive.box('journal_database');

  //load journal
  List<Journal> loadJournal() {
    List<Journal> savedJournalsFormatted = [];

    //if journals exists, return journal, else return empty list
    if (_mybox.get("ALL_JOURNALS") != null) {
      List<dynamic> savedJournals = _mybox.get("ALL_JOURNALS");
      for (int i = 0; i < savedJournals.length; i++) {
        //create individual journal
        Journal individualJournal =
            Journal(id: savedJournals[i][0], text: savedJournals[i][1]);
        //add to list
        savedJournalsFormatted.add(individualJournal);
      }
    } else {
      //default first journal
      savedJournalsFormatted.add(
        Journal(id: 0, text: 'First Journal'),
      );
    }
    return savedJournalsFormatted;
  }

  void savedJournals(List<Journal> allJournals) {
    List<List<dynamic>> allJournalsFormatted = [];

    //each journal has an id and text
    for (var journal in allJournals) {
      int id = journal.id;
      String text = journal.text;
      allJournalsFormatted.add([id, text]);
    }

    //storing into hive
    _mybox.put("ALL_JOURNALS", allJournalsFormatted);
  }
}
