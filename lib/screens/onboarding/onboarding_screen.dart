import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/onboarding/onboarding_bloc.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/bio_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/demo_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/email_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/location_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/pictures_screen.dart';

import '../../models/models.dart';
import '../../models/user_model.dart';
import 'onboarding_screens/start_screen.dart';

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
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
    Tab(text: 'Location'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      bloc: context.read<SignupCubit>(),
      listener: (context, SignupState state) {
        if (state.status == SignupStatus.success) {
          User u = User(
            id: context.read<SignupCubit>().state.user!.uid,
            name: '',
            age: 0,
            gender: '',
            imageUrls: [],
            interests: [],
            bio: '',
            jobTitle: '',
            radius: 0.0,
            longitude: 0.0,
            latitude: 0.0,
            matches: [],
            swipeLeft: [],
            swipeRight: [],
          );

          context.read<OnboardingBloc>().add(
                StartOnboarding(user: u),
              );
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: TabBarView(children: [
                Start(tabController: tabController),
                Email(tabController: tabController),
                Demographics(tabController: tabController),
                Pictures(tabController: tabController),
                Biography(tabController: tabController),
                LocationTab(tabController: tabController),
              ]));
        }),
      ),
    );
  }
}
