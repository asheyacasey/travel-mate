// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatelessWidget {
//   static const String routeName = '/profile';
//   static Route route() {
//     return MaterialPageRoute(
//         settings: RouteSettings(name: routeName),
//         builder: (context) {
//           print(BlocProvider.of<AuthBloc>(context).state);
//
//           return BlocProvider.of<AuthBloc>(context).state.status ==
//               AuthStatus.unauthenticated
//               ? OnboardingScreen()
//               : ProfileScreen();
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
