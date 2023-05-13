import 'package:flutter/material.dart';

class JournalContents extends StatelessWidget {
  final String journalName;

  JournalContents({required this.journalName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Text(journalName),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[200],
        ),
      ),
    );
  }
}
