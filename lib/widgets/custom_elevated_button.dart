import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color beginColor;
  final Color endColor;
  final Color textColor;
  final Function()? onPressed;

  const CustomElevatedButton(
      {Key? key,
        required this.text,
        required this.beginColor,
        required this.endColor,
        required this.textColor,
        this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
          // fixedSize: const Size(200, 40),
        ),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton2 extends StatelessWidget {
  final String text;
  final Color beginColor;
  final Color endColor;
  final Color textColor;
  final Function()? onPressed;

  const CustomElevatedButton2(
      {Key? key,
        required this.text,
        required this.beginColor,
        required this.endColor,
        required this.textColor,
        this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
          // fixedSize: const Size(200, 40),
        ),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

