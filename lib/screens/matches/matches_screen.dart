import 'package:flutter/material.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';
import 'package:travel_mate/widgets/user_image_small.dart';

import '../../models/models.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MatchesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inactiveMatches = UserMatch.matches
        .where((match) => match.userId == 1 && match.chat!.isEmpty)
        .toList();
    final activeMatches = UserMatch.matches
        .where((match) => match.userId == 1 && match.chat!.isNotEmpty)
        .toList();
    return Scaffold(
      appBar: CustomAppBar(title: 'MATCHES'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Matches',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: inactiveMatches.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        UserImageSmall(
                          height: 70,
                          width: 70,
                          imageUrl:
                              inactiveMatches[index].matchedUser.imageUrls[0],
                        ),
                        Text(inactiveMatches[index].matchedUser.name,
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Conversations',
                style: Theme.of(context).textTheme.headline4,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: activeMatches.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      UserImageSmall(
                        height: 70,
                        width: 70,
                        imageUrl: activeMatches[index].matchedUser.imageUrls[0],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeMatches[index].matchedUser.name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            activeMatches[index].chat![0].messages[0].message,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            activeMatches[index]
                                .chat![0]
                                .messages[0]
                                .timeString,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
