import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_mate/screens/journal/container.dart';
import 'package:travel_mate/screens/journal/database.dart';
import 'package:travel_mate/screens/journal/dialog_box.dart';
import 'package:travel_mate/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

class MainJournal extends StatefulWidget {
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
  final _controller = TextEditingController();
  JournalDatabase jd = JournalDatabase();
  final _mybox = Hive.box('mybox');

  @override
  void initState() {
    if (_mybox.get("POSTS") == null) {
      jd.createInitialData();
    } else {
      jd.loadData();
    }

    super.initState();
  }

  /**
   * creating the journal
   */
  void inputJournal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveJournal,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveJournal() {
    setState(() {
      jd.posts.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    jd.updateDatabase();
  }

  void deletePost(int index) {
    setState(() {
      jd.posts.removeAt(index);
    });
    jd.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Journal',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => inputJournal(context),
        child: Icon(UniconsLine.plus),
      ),
      body: ListView.builder(
        itemCount: jd.posts.length,
        itemBuilder: (context, index) {
          return JournalContents(
            journalName: jd.posts[index][0],
            deleteFunction: (context) => deletePost(index),
          );
        },
      ),
    );
  }
}
