// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? initialValue;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final EdgeInsets padding;

  const CustomTextField({
    Key? key,
    this.controller,
    this.isPassword = false,
    this.hint = '',
    this.initialValue = '',
    this.onFocusChanged,
    this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: TextField(
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          contentPadding:
              const EdgeInsets.only(bottom: 5.0, top: 12.5, left: 15.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF5C518), width: 2),
              borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: onChanged,
      ),
      onFocusChange: onFocusChanged ?? (hasFocus) {},
    );
  }
}
