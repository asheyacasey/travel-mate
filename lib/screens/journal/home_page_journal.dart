import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/screens/journal/journal_data.dart';
import 'package:travel_mate/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

import 'editingJournalPage.dart';
import 'journal.dart';

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

void createNewJournal(BuildContext context) {
  //creating a new ID
  int id =
      Provider.of<JournalData>(context, listen: false).getAllJournals().length;

  //create a blank journal
  Journal newJournal = Journal(
    id: id,
    text: '',
  );

  //go to edit the journal
  goToJournalPage(newJournal, true, context);
}

//go to journal editing page
void goToJournalPage(Journal journal, bool isNewJournal, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingJournalPage(
          journal: journal,
          isNewJournal: isNewJournal,
        ),
      ));
}

//delete the journal
void deleteJournal(Journal journal, BuildContext context) {
  Provider.of<JournalData>(context, listen: false).deleteJournal(journal);
}

class _JournalHomePageState extends State<JournalHomePage> {
  @override
  Widget build(BuildContext context) {
    var color = const Color(0xFFB0DB2D);
    return Consumer<JournalData>(
      builder: ((context, value, child) => Scaffold(
            backgroundColor: CupertinoColors.systemBackground,
            //appBar: CustomAppBar(title: 'Journal'),
            floatingActionButton: FloatingActionButton(
              onPressed: () => createNewJournal(context),
              child: Icon(UniconsLine.plus),
              backgroundColor: color,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    top: 75,
                  ),
                  child: Text(
                    'Journal',
                    style: TextStyle(
                        color: color,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                CupertinoListSection.insetGrouped(
                  children: List.generate(
                    value.getAllJournals().length,
                    (index) => CupertinoListTile(
                      title: Text(value.getAllJournals()[index].text),
                      onTap: () => goToJournalPage(
                          value.getAllJournals()[index], false, context),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
