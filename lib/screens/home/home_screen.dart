import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/screens/screens.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../onboarding/onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          print(BlocProvider.of<AuthBloc>(context).state.status);
          return BlocProvider.of<AuthBloc>(context).state.status ==
              AuthStatus.unauthenticated
              ? OnboardingScreen()
              :
          HomeScreen();
        });
  }

  Widget build(BuildContext context) {
  return Scaffold();
  }
}

