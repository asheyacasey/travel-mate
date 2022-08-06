import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:travel_mate/screens/home/home_screen.dart';
import 'config/app_router.dart';
import 'config/theme.dart';
import 'screens/splash/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'TravelMate',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: HomeScreen.routeName,
    );
  }
}
