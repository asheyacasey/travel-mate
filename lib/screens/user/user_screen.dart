import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/widgets/choice_button.dart';
import 'package:unicons/unicons.dart';

import '../../models/user_model.dart';

class UsersScreen extends StatelessWidget {
  static const String routeName = '/users';

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => UsersScreen(user: user),
    );
  }

  final User user;

  const UsersScreen({required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Hero(
                    tag: 'user_image',
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrls[0]),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceButton(
                            width: 80,
                            size: 30,
                            height: 80,
                            color: Colors.blueGrey,
                            icon:  UniconsSolid.times_circle,
                            hasGradient: true),
                        PrimaryButton(
                          width: 80,
                          height: 80,
                          size: 30,
                          color: Colors.white,
                          icon: UniconsSolid.favorite,
                          hasGradient: true,

                        ),
                        ChoiceButton(
                            width: 80,
                            size: 30,
                            height: 80,
                            color: Theme.of(context).primaryColor,
                            icon:  UniconsSolid.check_circle,
                            hasGradient: true)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox( height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),

            child:

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  '${user.name}, ${user.age}',
                  style: Theme.of(context).primaryTextTheme.headline2!.copyWith(
                      fontFamily: GoogleFonts.fredoka().fontFamily,
                      fontWeight: FontWeight.w900,
                      color: Colors.black ),

                ),
                Text(
                  '${user.jobTitle}',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                SizedBox(height: 15),
                Text('About',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                Text('${user.bio}',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          height: 2,
                        )),
                SizedBox(height: 15),
                Text('Interest',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                Row(
                  children: user.interests
                      .map((interest) => Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.only(top: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              interest,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white),
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


