import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
