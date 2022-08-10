import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travel_mate/screens/screens.dart';

import 'blocs/blocs.dart';
import 'config/app_router.dart';
import 'config/theme.dart';
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
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            //here's the problem
            create: (_) => SwipeBloc()
              ..add(
                LoadUsers(
                  users: User.users.where((user) => user.id != 1).toList(),
                ),
              ), // users: User.users.where((where) => user.id != 1 ).toList(), -- don't delete this comment
            // users: User.users
          ),
          BlocProvider(
            create: (_) => ImagesBloc(
              databaseRepository: DatabaseRepository(),
            )..add(
                LoadImages(),
              ),
          ),
        ],
        child: MaterialApp(
          title: 'TravelMate',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: OnboardingScreen.routeName,
        ),
      ),
    );
  }
}
