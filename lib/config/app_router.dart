import 'package:flutter/material.dart';
import 'package:travel_mate/models/models.dart';
import 'package:travel_mate/screens/journal/mainJournal.dart';
import 'package:travel_mate/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');

    print(settings);
    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case UsersScreen.routeName:
        return UsersScreen.route(
            user:
                settings.arguments as User); // user: settings.arguments as User
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      // case LocationScreen.routeName:
      //   return MainMapScreen.route();
      case MainJournal.routeName:
        return MainJournal.route();
      case MatchesScreen.routeName:
        return MatchesScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route(match: settings.arguments as Match);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
      settings: RouteSettings(name: '/error'),
    );
  }
}
