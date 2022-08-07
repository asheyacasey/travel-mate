import 'package:flutter/material.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/demo_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/email_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/email_verification_screen.dart';
import 'package:travel_mate/widgets/widgets.dart';

import 'onboarding_screens/start_screen.dart';
import 'onboarding_screens/email_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Email Verification'),
    Tab(text: 'Demographics'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
            appBar: CustomAppBar(
              title: 'TravelMate',
              hasAction: false,
            ),
            body: TabBarView(children: [
              Start(tabController: tabController),
              Email(tabController: tabController),
              EmailVerification(tabController: tabController),
              Demographics(tabController: tabController),
            ]));
      }),
    );
  }
}
