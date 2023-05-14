import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/journal.dart';
import 'package:travel_mate/screens/journal/localDatabase.dart';

class JournalData extends ChangeNotifier {
  /**
   * hive database
   */
  final db = LocalDatabase();

  /**
   * overall list of journals
   */
  List<Journal> allJournals = [];

  /**
   * initialize list in db
   */
  void initializeJournals() {
    allJournals = db.loadJournal();
  }

  /**
   * getting the journals
   */
  List<Journal> getAllJournals() {
    return allJournals;
  }

  /**
   * adding a new journal
   */
  void addNewJournal(Journal journal) {
    allJournals.add(journal);
    notifyListeners();
    db.savedJournals(allJournals);
  }

  /**
   * updating the journal
   */
  void updateJournal(Journal journal, String text) {
    //go thru list of all notes
    for (int i = 0; i < allJournals.length; i++) {
      //find relevant journal
      if (allJournals[i].id == journal.id) {
        //replace the journal
        allJournals[i].text = text;
      }
    }
    notifyListeners();
    db.savedJournals(allJournals);
  }

  /**
   * deleteting the journal
   */
  void deleteJournal(Journal journal) {
    allJournals.remove(journal);
    notifyListeners();
    db.savedJournals(allJournals);
  }
}
