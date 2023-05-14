import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/journal.dart';

class JournalData extends ChangeNotifier {
  /**
   * overall list of journals
   */
  List<Journal> allJournals = [
    Journal(id: 0, text: 'First Journal'),
    Journal(id: 1, text: 'Second Journal'),
  ];

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
  }

  /**
   * deleteting the journal
   */
  void deleteJournal(Journal journal) {
    allJournals.remove(journal);
    notifyListeners();
  }
}
