import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  const Modal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 300,
        child: Text('testinggggggggggg.......'),
      ),
    );
  }
}
