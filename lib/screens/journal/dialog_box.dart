import 'package:flutter/material.dart';
import 'package:travel_mate/screens/journal/buttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  const DialogBox({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[100],
      content: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "How are you feeling today?",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DialogButton(
                  text: "Save",
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20,
                ),
                DialogButton(
                  text: "Cancel",
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
