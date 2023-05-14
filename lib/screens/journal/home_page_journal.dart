import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/widgets/widgets.dart';

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, value, child) => Scaffold()),
    );
  }
}
