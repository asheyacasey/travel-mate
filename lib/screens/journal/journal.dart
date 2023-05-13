import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/screens/journal/container.dart';

import '../../blocs/blocs.dart';
import '../../repositories/repositories.dart';
import '../login/login_screen.dart';

class MainJournal extends StatelessWidget {
  static const String routeName = '/mainJournal';

  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: RouteSettings(name: routeName),
  //     builder: (context) => MainJournal(),
  //   );
  // }

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          print(BlocProvider.of<AuthBloc>(context).state.status);
          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.unauthenticated
              ? LoginScreen()
              : BlocProvider<ProfileBloc>(
                  create: (context) => ProfileBloc(
                    authBloc: BlocProvider.of<AuthBloc>(context),
                    databaseRepository: context.read<DatabaseRepository>(),
                    //locationRepository: context.read<LocationRepository>(),
                  )..add(
                      LoadProfile(
                          userId: context.read<AuthBloc>().state.authUser!.uid),
                    ),
                  child: MainJournal(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text("Hi kapoy"),
      ),
    );
  }
}
