import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/widgets/user_image_small.dart';
import 'package:unicons/unicons.dart';

import '../models/user_model.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'user_image',
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user.imageUrls[0]),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ))),
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: Theme.of(context).primaryTextTheme.headline2!.copyWith(
                          fontFamily: GoogleFonts.fredoka().fontFamily,
                          fontWeight: FontWeight.w900,
                          color: Colors.white ),
                    ),
                    Text(
                      '${user.jobTitle}',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Row(
                      children: [
                        UserImageSmall(imageUrl: user.imageUrls[1]),
                        UserImageSmall(imageUrl: user.imageUrls[2]),
                        UserImageSmall(imageUrl: user.imageUrls[3]),
                        UserImageSmall(imageUrl: user.imageUrls[4]),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: Icon(UniconsLine.info_circle,
                            size: 25, color: Theme.of(context).primaryColor,

                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
