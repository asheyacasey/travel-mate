import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';
import 'package:travel_mate/repositories/auth/auth_repository.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/repositories/repositories.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/bio_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/demo_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/email_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/email_verification_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/location_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/pictures_screen.dart';

import 'onboarding_screens/start_screen.dart';
import 'onboarding_screens/email_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (_) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<OnboardingBloc>(
            create: (_) => OnboardingBloc(
              databaseRepository: DatabaseRepository(),
              storageRepostitory: StorageRepository(),
            )..add(
                StartOnboarding(),
              ),
          )
        ],
        child: OnboardingScreen(),
      ),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Email Verification'),
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
    Tab(text: 'Location'),
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
            resizeToAvoidBottomInset: false,
            body: TabBarView(children: [
              Start(tabController: tabController),
              Email(tabController: tabController),
              EmailVerification(tabController: tabController),
              Demographics(tabController: tabController),
              Pictures(tabController: tabController),
              Biography(tabController: tabController),
              Location(tabController: tabController),
            ]));
      }),
    );
  }
}
