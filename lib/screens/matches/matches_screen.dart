import 'package:flutter/material.dart';
import 'package:travel_mate/blocs/auth/auth_bloc.dart';
import 'package:travel_mate/blocs/match/match_bloc.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';
import 'package:travel_mate/widgets/custom_elevated_button.dart';
import 'package:travel_mate/widgets/user_image_small.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../chat/chat_screen.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MatchBloc>(
        create: (context) => MatchBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(
            LoadMatches(user: context.read<AuthBloc>().state.user!),
          ),
        child: MatchesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'TravelMate'),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MatchLoaded) {
            final inactiveMatches = state.matches
                .where((match) => match.chat.messages.length == 0)
                .toList();
            final activeMatches = state.matches
                .where((match) => match.chat.messages.length > 0)
                .toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Matches',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    MatchesList(inactiveMatches: inactiveMatches),
                    Text(
                      'Conversations',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    ChatsList(activeMatches: activeMatches),
                  ],
                ),
              ),
            );
          }
          if (state is MatchUnavailable) {
            return Column(
              children: [
                Text(
                  'You have no matches yet.',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(
                  text: 'Back To Home Screen',
                  beginColor: Theme.of(context).accentColor,
                  endColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          } else {
            return Center(
              child: Text('Something went wrong.'),
            );
          }
        },
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({
    Key? key,
    required this.activeMatches,
  }) : super(key: key);

  final List<Match> activeMatches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: activeMatches.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.routeName,
                arguments: activeMatches[index]);
          },
          child: Row(
            children: [
              UserImageSmall(
                height: 70,
                width: 70,
                imageUrl: activeMatches[index].matchUser.imageUrls[0],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeMatches[index].matchUser.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    activeMatches[index].chat.messages[0].message,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    activeMatches[index].chat.messages[0].timeString,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class MatchesList extends StatelessWidget {
  const MatchesList({
    Key? key,
    required this.inactiveMatches,
  }) : super(key: key);

  final List<Match> inactiveMatches;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: inactiveMatches.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.routeName,
                  arguments: inactiveMatches[index]);
            },
            child: Column(
              children: [
                UserImageSmall(
                  height: 70,
                  width: 70,
                  imageUrl: inactiveMatches[index].matchUser.imageUrls[0],
                ),
                Text(inactiveMatches[index].matchUser.name,
                    style: Theme.of(context).textTheme.headline5),
              ],
            ),
          );
        },
      ),
    );
  }
}
