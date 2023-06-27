import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/widgets/user_image.dart';

import 'dart:math' show cos, sqrt, asin;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
              UserImage.large(
                url: user.imageUrls[0],
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
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline2!
                          .copyWith(
                              fontFamily: GoogleFonts.fredoka().fontFamily,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                    ),
                    Text(
                      '${user.jobTitle}',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    FutureBuilder<String>(
                      future: calculateUserDistance(user.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            '${snapshot.data} km away',
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: user.imageUrls.length + 1,
                        itemBuilder: (builder, index) {
                          return index < user.imageUrls.length
                              ? UserImage.small(
                                  url: user.imageUrls[index],
                                  margin: const EdgeInsets.only(
                                    top: 8.0,
                                    right: 8.0,
                                  ),
                                )
                              : Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                );
                        },
                      ),
                    ),
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

Future<String> calculateUserDistance(String user2uid) async {
  final user1 = auth.FirebaseAuth.instance.currentUser;
  final user2Doc =
      await FirebaseFirestore.instance.collection('users').doc(user2uid).get();

  if (user1 != null && user2Doc.exists) {
    var user1Data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user1.uid)
        .get();
    var user2Data = user2Doc.data();

    LatLng user1Position =
        LatLng(user1Data.data()?['latitude'], user1Data.data()?['longitude']);
    LatLng user2Position =
        LatLng(user2Data?['latitude'], user2Data?['longitude']);

    print('$user1Position user 1 position');
    print('$user2Position user 2 position');

    var distance = calculateDistance(user1Position, user2Position);
    var formattedDistance = distance.toStringAsFixed(1);

    print('Distance between user1 and user2 is $distance km');
    return formattedDistance;
  }
  throw Exception('Could not calculate distance');
}

double calculateDistance(LatLng pos1, LatLng pos2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((pos2.latitude - pos1.latitude) * p) / 2 +
      c(pos1.latitude * p) *
          c(pos2.latitude * p) *
          (1 - c((pos2.longitude - pos1.longitude) * p)) /
          2;
  return 12742 * asin(sqrt(a));
}
