import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/widgets/custom_elevated_button.dart';

import 'package:unicons/unicons.dart';
import '../../blocs/blocs.dart';
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
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        print('state');
        if (state is SwipeLoading) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Discover'),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is SwipeLoaded) {
          return SwipeLoadedHomeScreen(state: state);
        }

        if (state is SwipeMatched) {
          return SwipedMatchedHomeScreen(state: state);
        }

        if (state is SwipeError) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Discover'),
            body: Center(
              child: Text('There aren\'t any more users.',
                  style: Theme.of(context).textTheme.headline4),
            ),
          );
        } else {
          return Scaffold(
            appBar: CustomAppBar(title: 'Discover'),
            body: Center(child: Text('Something went wrong.')),
          );
        }
      },
    );
  }
}

class SwipedMatchedHomeScreen extends StatelessWidget {
  const SwipedMatchedHomeScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SwipeMatched state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congrats, it\'s a match!',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 20),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor,
                    ])),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        context.read<AuthBloc>().state.user!.imageUrls[0],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).primaryColor,
                    ])),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        state.user.imageUrls[0],
                      ),
                      //gi try nako remove to ang '!'
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            CustomElevatedButton(
              text: 'Send a message',
              beginColor: Colors.white,
              endColor: Colors.white,
              textColor: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            CustomElevatedButton(
              text: 'Back to Swiping',
              beginColor: Theme.of(context).primaryColor,
              endColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              onPressed: () {
                context
                    .read<SwipeBloc>()
                    .add(LoadUsers(user: context.read<AuthBloc>().state.user!));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeLoadedHomeScreen extends StatelessWidget {
  const SwipeLoadedHomeScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SwipeLoaded state;

  @override
  Widget build(BuildContext context) {
    var userCount = state.users.length;

    return Scaffold(
      appBar: CustomAppBar(title: 'Discover'),
      body: Column(
        children: [
          InkWell(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/users', arguments: state.users[0]);
            },
            child: Draggable(
              child: UserCard(user: state.users[0]),
              feedback: UserCard(user: state.users[0]),
              childWhenDragging: (userCount > 1)
                  ? UserCard(user: state.users[1])
                  : Container(),
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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()
                      ..add(SwipeLeft(user: state.users[0]));
                    print('Swiped Left');
                  },
                  child: ChoiceButton(
                    height: 60,
                    width: 60,
                    size: 30,
                    hasGradient: false,
                    color: Colors.blueGrey,
                    icon: UniconsSolid.times_circle,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()
                      ..add(SwipeRight(user: state.users[0]));
                    print('Swiped ');
                  },
                  child: PrimaryButton(
                    width: 70,
                    height: 70,
                    size: 40,
                    hasGradient: true,
                    color: Colors.white,
                    icon: UniconsSolid.favorite,
                  ),
                ),
                ChoiceButton(
                  height: 60,
                  width: 60,
                  size: 30,
                  hasGradient: false,
                  color: Theme.of(context).primaryColor,
                  icon: UniconsSolid.check_circle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
