import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/cubits/cubits.dart';
import 'package:travel_mate/blocs/profile/profile_bloc.dart';

import 'package:travel_mate/screens/screens.dart';

import 'blocs/blocs.dart';
import 'config/app_router.dart';
import 'config/theme.dart';
import 'cubits/signup/signup_cubit.dart';
import 'models/user_model.dart';
import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<LoginCubit>(
            create: (context) =>
                LoginCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepostitory: context.read<StorageRepository>(),
            ),
          ),
          BlocProvider(
            //here's the problem
            create: (context) => SwipeBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(
                LoadProfile(userId: context.read<AuthBloc>().state.user!.uid),
              ),
          ),
        ],
        child: MaterialApp(
          title: 'TravelMate',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
