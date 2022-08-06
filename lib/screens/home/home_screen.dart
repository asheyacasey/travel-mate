import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/user_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  // static Route route() {
  //   return MaterialPageRoute(
  //       settings: RouteSettings(name: routeName),
  //       builder: (context) {
  //         print(BlocProvider.of<AuthBloc>(context).state.status);
  //         return BlocProvider.of<AuthBloc>(context).state.status ==
  //             AuthStatus.unauthenticated
  //             ? OnboardingScreen()
  //             :
  //         HomeScreen();
  //       });
  // }

  static Route route() {
    return MaterialPageRoute(
        builder: (_) => HomeScreen(), settings: RouteSettings(name: routeName));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          UserCard(user: User.users[0]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceButton(
                    height: 60,
                    width: 60,
                    size: 30,
                    hasGradient: false,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.clear_rounded),
                ChoiceButton(
                  width: 70,
                  height: 70,
                  size: 40,
                  hasGradient: true,
                  color: Theme.of(context).primaryColor,
                  icon: Icons.favorite,
                ),
                ChoiceButton(
                  height: 60,
                  width: 60,
                  size: 30,
                  hasGradient: false,
                  color: Theme.of(context).colorScheme.secondary,
                  icon: Icons.watch_later,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double size;
  final Color color;
  final bool hasGradient;
  final IconData icon;

  const ChoiceButton({
    Key? key,
    required this.width,
    required this.size,
    required this.height,
    required this.color,
    required this.icon,
    required this.hasGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          // gradient: hasGradient
          //     ? LinearGradient(
          //         colors: [
          //           Theme.of(context).primaryColor,
          //           Theme.of(context).colorScheme.secondary,
          //         ],
          //       )
          //     : LinearGradient(
          //         colors: [
          //          Colors.white,
          //           Colors.white,
          //         ],
          //       ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(3, 3),
            )
          ]),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }
}
