import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:unicons/unicons.dart';

class JournalContents extends StatelessWidget {
  final String journalName;
  Function(BuildContext)? deleteFunction;

  JournalContents({
    required this.journalName,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      // child: Slidable(
      // endActionPane: ActionPane(
      //   motion: StretchMotion(),
      //   children: [
      //     SlidableAction(
      //       onPressed: deleteFunction,
      //       icon: Icons.delete,
      //       backgroundColor: Colors.red.shade300,
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ],
      // ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Text(journalName),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[200],
        ),
      ),
      //),
    );
  }
}
