import 'package:flutter/material.dart';
import 'package:travel_mate/widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ARROW',
        hasAction: false,
      ),
      body: Container(),
    );
  }
}
