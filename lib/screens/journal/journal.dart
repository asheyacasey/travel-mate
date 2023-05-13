import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/screens/journal/container.dart';
import 'package:travel_mate/screens/screens.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../repositories/repositories.dart';
import '../../widgets/widgets.dart';

class MainJournal extends StatelessWidget {
  static const String routeName = '/mainJournal';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MainJournal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Journal'),
    );
  }
}
