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
                          height: 70,
                          width: 120,
                          size: 40,
                          hasGradient: false,
                          color: Colors.white,
                          icon: UniconsSolid.times_circle,
                        ),
                        PrimaryButton(
                          width: 120,
                          height: 70,
                          size: 40,
                          hasGradient: true,
                          color: Colors.white,
                          icon: UniconsSolid.favorite,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${user.name}, ${user.age} ',
                      style: GoogleFonts.fredokaOne(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                  child: Text(
                    '${user.jobTitle}',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black54),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Text('About ${user.name}',
                      style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                      ),),
                    SizedBox(width: 5.0,),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        UniconsLine.google_hangouts_alt,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),

                Text('${user.bio}',
                    style: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        fontSize: 26,
                        color: Colors.black54,
                        fontWeight: FontWeight.w800,
                      ),
                    ),),
                SizedBox(height: 30),
                Text('Interest',
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w800,
                    ),
                  ),),
                Row(
                  children: user.interests
                      .map((interest) => Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.only(top: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              interest,
                              style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,

                                ),
                              ),),
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
