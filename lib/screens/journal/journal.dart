import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/container.dart';
import 'package:travel_mate/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

class MainJournal extends StatelessWidget {
  static const String routeName = '/mainJournal';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Journal'),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return JournalContents(
            child: _posts[index],
          );
        },
      ),
      floatingActionButton: addJournal(),
    );
  }

  Widget addJournal() => FloatingActionButton(
        child: Icon(UniconsLine.plus),
        onPressed: () {
          print('pressed');
        },
      );
}
