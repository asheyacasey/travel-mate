import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/models/models.dart';
import 'package:travel_mate/screens/chat/packageDetails_screen.dart';
import 'dart:math';

class PackagesScreen extends StatefulWidget {
  final int numberOfDays;
  final Match match;

  PackagesScreen({required this.numberOfDays, required this.match});

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<String> randomTitles = [];
  int lastUsedTitleIndex = -1;

  @override
  void initState() {
    super.initState();
    _shuffleRandomTitles();
  }

  void _shuffleRandomTitles() {
    randomTitles = [
          "Sweetheart Soiree",
          "Lovely Rendezvous",
          "Adorable Adventure",
          "Charming Getaway",
          "Whimsical Wanderlust",
          "Enchanting Excursion",
          "Playful Retreat",
          "Darling Escape",
          "Romantic Roaming",
          "Magical Memories",
          "Cuddlesome Journey",
          "Blissful Expedition",
          "Heartwarming Holiday",
          "Dreamy Discovery",
          "Sunny Serenade",
          "Cozy Caravan",
          "Honeybee Honeymoon",
          "Cherished Trails",
          "Sparkling Stroll",
          "Smitten Sightseeing",
    ];
    randomTitles.shuffle();
    lastUsedTitleIndex = -1;
  }

  String _getNextRandomTitle() {
    lastUsedTitleIndex++;
    if (lastUsedTitleIndex >= randomTitles.length) {
      _shuffleRandomTitles();
      lastUsedTitleIndex = 0;
    }
    return randomTitles[lastUsedTitleIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'travel',
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF5C518), // First color
                  ),
                ),
              ),
              TextSpan(
                text: 'mate',
                style: GoogleFonts.fredokaOne(
                  textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB0DB2D), // Second color
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Travel Date Plans',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB0DB2D),
                            )),
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Color(0xFFDADADA),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Package>>(
                  future: generatePackagesFromFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Package> packages = snapshot.data!;
                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          Package package = packages[index];
                          String randomTitle = _getNextRandomTitle();
                          return Card(
                            child: ListTile(
                              title: Text(
                                randomTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Around Cebu",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Total Duration: ${package.totalDuration} minutes',
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PackageDetailsScreen(
                                      package: package,
                                      numberOfDays: widget.numberOfDays,
                                      match: widget.match,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Package>> generatePackagesFromFirebase() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('business').get();

    List<Activity> activities = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      List<dynamic> activityList = doc['activities'];
      List<Activity> tempActivities = [];

      activityList.forEach((activityData) {
        TimeOfDay startTime = _convertToTimeOfDay(activityData['startTime']);
        TimeOfDay endTime = _convertToTimeOfDay(activityData['endTime']);

        Activity activity = Activity(
          activityName: activityData['name'],
          category: activityData['category'],
          address: activityData['address'],
          timeStart: startTime,
          timeEnd: endTime,
          duration: activityData['duration'],
        );

        // Check if activity with the same activityName and address already exists in activities list
        bool activityExists = activities.any((existingActivity) =>
        existingActivity.activityName == activity.activityName &&
            existingActivity.address == activity.address);

        if (!activityExists) {
          tempActivities.add(activity);
        }
      });

      tempActivities.sort((a, b) {
        DateTime dateTimeA = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          a.timeStart.hour,
          a.timeStart.minute,
        );
        DateTime dateTimeB = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          b.timeStart.hour,
          b.timeStart.minute,
        );

        int timeComparison = dateTimeA.compareTo(dateTimeB);
        if (timeComparison != 0) {
          return timeComparison; // Sort by start time
        } else {
          return a.duration
              .compareTo(b.duration); // Sort by duration (secondary criteria)
        }
      });

      activities.addAll(tempActivities);
    }

    return generatePackages(activities, widget.numberOfDays);
  }

  TimeOfDay _convertToTimeOfDay(Map<String, dynamic> timeMap) {
    int hour = timeMap['hour'];
    int minute = timeMap['minute'];
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<Package> generatePackages(List<Activity> activities, int numberOfDays) {
    List<Package> packages = [];
    Package currentPackage = Package(activities: []);

    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      int totalDuration = currentPackage.totalDuration + activity.duration;

      if (totalDuration <= (numberOfDays * 180)) {
        currentPackage.activities.add(activity);
      } else {
        packages.add(currentPackage);
        currentPackage = Package(activities: [activity]);
      }
    }

    if (currentPackage.activities.isNotEmpty) {
      packages.add(currentPackage);
    }

    return packages;
  }
}

class Activity {
  final String activityName;
  final String category;
  final String address;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;
  final int duration;

  Activity({
    required this.activityName,
    required this.category,
    required this.address,
    required this.timeStart,
    required this.timeEnd,
    required this.duration,
  });

  Map<String, dynamic> toMap(BuildContext context) {
    return {
      'activityName': activityName,
      'category': category,
      'address': address,
      'timeStart': timeStart.format(context),
      'timeEnd': timeEnd.format(context),
      'duration': duration,
    };
  }

  factory Activity.fromFirebaseMap(
      Map<String, dynamic> map, BuildContext context) {
    return Activity(
      activityName: map['activityName'],
      category: map['category'],
      address: map['address'],
      timeStart: TimeOfDay.fromDateTime(
        DateFormat.Hm().parse(map['timeStart']),
      ),
      timeEnd: TimeOfDay.fromDateTime(
        DateFormat.Hm().parse(map['timeEnd']),
      ),
      duration: map['duration'],
    );
  }
}

class Package {
  final List<Activity> activities;

  Package({this.activities = const []});

  int get totalDuration {
    int total = 0;
    activities.forEach((activity) {
      total += activity.duration;
    });
    return total;
  }
}
