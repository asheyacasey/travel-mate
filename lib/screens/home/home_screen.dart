import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Discover',
      ),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if (state is SwipeLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SwipeLoaded) {
            var userCount = state.users.length;
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
                    childWhenDragging:
                    (userCount > 1 ) ?
                    UserCard(user: state.users[1]) :
                    Container()
                    ,
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
                      InkWell(
                        onTap: (){
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
                            icon:  UniconsSolid.times_circle,
                        ),
                      ),
                      InkWell(
                        onTap: (){
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
            );
          }

          if(state is SwipeError){
            return Center(
              child: Text('There aren\'t any more users.',
              style: Theme.of(context).textTheme.headline4,
              ),
            );

          }  else {
            return Text('Something went wrong.');
          }




        },
      ),
    );
  }
}
