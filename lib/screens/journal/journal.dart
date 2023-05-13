import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/container.dart';
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

  /**
   * dynamically creating a list
   */
  List _posts = [
    ["Journal 1"],
    ["Journal 2"],
  ];

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
      _posts.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
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
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return JournalContents(journalName: _posts[index][0]);
        },
      ),
    );
  }
}
