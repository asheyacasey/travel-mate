import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CheckBox extends StatefulWidget {
  final String? title;
  const CheckBox({Key? key, required this.title,})
      : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.green,
      value: value,
      title: Text(
        widget.title!,
        style: TextStyle(fontSize: 15),
      ),
      onChanged: (value) {
        setState(() {
          value = value!;
        });
      },
    );
  }
}
