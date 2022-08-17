import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
        required this.width,
        required this.height,
        required this.size,
        required this.color,
        required this.hasGradient,
        required this.icon})
      : super(key: key);

  final double width;
  final double height;
  final double size;
  final Color color;
  final bool hasGradient;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(3, 3),
            )
          ]),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double size;
  final Color color;
  final bool hasGradient;
  final IconData icon;

  const ChoiceButton({
    Key? key,
    required this.width,
    required this.size,
    required this.height,
    required this.color,
    required this.icon,
    required this.hasGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(3, 3),
            )
          ]),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}