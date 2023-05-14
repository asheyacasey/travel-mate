import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/buttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox(
      {Key? key,
      required this.controller,
      required this.onSave,
      required this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[100],
      content: Container(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Title",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(
                fontSize: 14,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "How are you feeling today?",
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogButton(
                  text: "Save",
                  onPressed: onSave,
                ),
                SizedBox(
                  width: 20,
                ),
                DialogButton(
                  text: "Cancel",
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
