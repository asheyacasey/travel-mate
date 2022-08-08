import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/swipe_bloc.dart';

import '../../widgets/choice_button.dart';
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
      appBar: CustomAppBar(
        title: 'DISCOVER',
      ),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if (state is SwipeLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SwipeLoaded) {
            return Column(
              children: [
                InkWell(
                  onDoubleTap: () {
                    Navigator.pushNamed(context, '/users',
                        arguments: state.users[0]);
                  },
                  child: Draggable(
                    child: UserCard(user: state.users[0]),
                    feedback: UserCard(user: state.users[0]),
                    childWhenDragging: UserCard(user: state.users[1]),
                    onDragEnd: (drag) {
                      if (drag.velocity.pixelsPerSecond.dx < 0) {
                        context.read<SwipeBloc>()
                          ..add(SwipeLeft(user: state.users[0]));
                        print('Swiped Left');
                      } else {
                        context.read<SwipeBloc>()
                          ..add(SwipeRight(user: state.users[0]));
                        print('Swiped Right');
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChoiceButton(
                          height: 60,
                          width: 60,
                          size: 30,
                          hasGradient: false,
                          color: Colors.red,
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
            );
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }
}
