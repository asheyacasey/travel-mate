
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_mate/widgets/custom_elevated_button.dart';
import 'package:unicons/unicons.dart';
import '../../blocs/blocs.dart';
import '../../widgets/choice_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/user_card.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('There aren\'t any more users.',
                      style: Theme.of(context).textTheme.headline4),
                  Text('Edit your preferences to see more users.',
                      style: Theme.of(context).textTheme.headline4),
                ],
              ),
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
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: GoogleFonts.manrope(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).primaryColor,
                    ])),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        context.read<AuthBloc>().state.user!.imageUrls[0],
                      ),
                    ),
                  ),
                ),
                //const SizedBox(width: 5),
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).primaryColor,
                    ])),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        state.user.imageUrls[0],
                      ),
                      //gi try nako remove to ang '!'
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomElevatedButton(
              text: 'Send a message',
              beginColor: Theme.of(context).primaryColor,
              endColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            CustomElevatedButton4(
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
                    height: 70,
                    width: 120,
                    size: 40,
                    hasGradient: false,
                    color: Colors.white,
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
                    width: 120,
                    height: 70,
                    size: 40,
                    hasGradient: true,
                    color: Colors.white,
                    icon: UniconsSolid.favorite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
