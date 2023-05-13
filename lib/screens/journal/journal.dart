import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/container.dart';
import 'package:travel_mate/screens/journal/dialog_box.dart';
import 'package:travel_mate/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

class MainJournal extends StatelessWidget {
  static const String routeName = '/mainJournal';

  final _controller = TextEditingController();

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MainJournal(),
    );
  }

  /**
   * dynamically creating a list
   */
  final List _posts = [
    'Journal 1',
    'Journal 2',
    'Journal 3',
    'Journal 4',
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
        );
      },
    );
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
          return JournalContents(
            child: _posts[index],
          );
        },
      ),
    );
  }
}
