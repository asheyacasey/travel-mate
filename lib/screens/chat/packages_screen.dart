import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/models/models.dart';
import 'package:travel_mate/screens/chat/packageDetails_screen.dart';
import 'dart:math' as math;
import 'package:unicons/unicons.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class PackagesScreen extends StatefulWidget {
  final int numberOfDays;
  final Match match;
  final User currentUser;
  final double lat;
  final double lon;

  PackagesScreen(
      {required this.numberOfDays,
      required this.match,
      required this.currentUser,
      required this.lat,
      required this.lon});

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<String> randomTitles = [];
  int lastUsedTitleIndex = -1;
  bool hasActivities = false;
  Future<List<Package>>? _packagesFuture;
  double _defaultRadius = 1000.0;
  List<Activity> fetchedActivities = [];

  @override
  void initState() {
    super.initState();
    _packagesFuture = generatePackagesFromFirebase();
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

  String getTripDurationText(int numberOfDays) {
    if (numberOfDays == 1) {
      return '1 day';
    } else if (numberOfDays == 2) {
      return '2 days and 1 night';
    } else if (numberOfDays > 2) {
      int numberOfNights = numberOfDays - 1;
      return '$numberOfDays days, $numberOfNights nights';
    } else {
      return ''; // Handle other cases if needed
    }
  }

  void _onRadiusChanged(int handlerIndex, lowerValue, upperValue) {
    setState(() {
      _defaultRadius = lowerValue;
    });
  }

  // Function to fetch activities again with the new radius and generate new packages.
  void _applyNewRadius() {
    setState(() {
      _packagesFuture = generatePackagesFromFirebase();
    });
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Adjust Radius"),
                        FlutterSlider(
                          values: [_defaultRadius],
                          max:
                              100000.0, // Adjust the max value according to your requirement.
                          min:
                              1000.0, // Adjust the min value according to your requirement.
                          step: FlutterSliderStep(
                              step:
                                  10000.0), // Adjust the step value according to your requirement.
                          onDragging: _onRadiusChanged,
                          trackBar: FlutterSliderTrackBar(
                            activeTrackBar: BoxDecoration(
                              color: Colors
                                  .blue, // Customize the color of the active part of the Slider
                            ),
                            inactiveTrackBar: BoxDecoration(
                              color: Colors
                                  .grey, // Customize the color of the inactive part of the Slider
                            ),
                          ),
                          handler: FlutterSliderHandler(
                            child: Icon(
                              Icons
                                  .circle, // Customize the appearance of the handler (dot/tick).
                              color: Colors
                                  .blue, // Customize the color of the handler (dot/tick).
                              size:
                                  20.0, // Customize the size of the handler (dot/tick).
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Apply the new radius when the button is clicked.
                            _applyNewRadius();
                            Navigator.of(context).pop();
                          },
                          child: Text("Apply Radius"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
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
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Travel Date Plans',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.manrope(
                                  textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB0DB2D),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Image.asset(
                          'assets/coverphoto.png', // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ],
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
                  future: _packagesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Package> packages = snapshot.data!;
                      if (hasActivities) {
                        return ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: packages.length,
                          itemBuilder: (context, index) {
                            Package package = packages[index];
                            String randomTitle = _getNextRandomTitle();
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Color(0xFFFAE4A1),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 4.0),
                                    child: Text(
                                      randomTitle,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Around Cebu",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Trip Duration: ${getTripDurationText(widget.numberOfDays)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  trailing: Icon(
                                    UniconsLine.angle_right_b,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PackageDetailsScreen(
                                          lat: widget.lat,
                                          lon: widget.lon,
                                          radius: _defaultRadius,
                                          fetchedActivities: fetchedActivities,
                                          package: package,
                                          numberOfDays: widget.numberOfDays,
                                          match: widget.match,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No or not enough activities found in the area.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
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
    List interests =
        widget.match.matchUser.interests + widget.currentUser.interests;

    double _mapRadius = _defaultRadius / 1000;

    // Convert interests list to List<String>
    List<String> stringInterests =
        interests.map((interest) => interest.toString()).toList();

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
          lat: activityData['lat'],
          lon: activityData['long'],
          timeStart: startTime,
          timeEnd: endTime,
          duration: activityData['duration'],
        );

        // Check if activity with the same activityName and address already exists in activities list
        bool activityExists = activities.any((existingActivity) =>
            existingActivity.activityName == activity.activityName &&
            existingActivity.address == activity.address);

        if (!activityExists) {
          // Calculate the distance between the inputted place and the location of the activity
          double distance = calculateDistance(
            widget.lat,
            widget.lon,
            activity.lat,
            activity.lon,
          );

          print("WIDGET LAT ${widget.lat}");
          print("WIDGET LONG ${widget.lon}");
          print("ACTIVITY LAT ${activity.lat}");
          print("ACTIVITY LONG ${activity.lon}");
          print(
              'ACTIVITY NAME ${activity.activityName} AND CATEGORY ${activity.category}');
          stringInterests.forEach((interest) => print(interest));

          bool isWithinMaxDistance = distance <= _mapRadius;

          print(
              "ACTIVITYNAME IS ${activity.activityName} ADDRESS IS ${activity.address} DISTANCE IS ${distance} AND RADIUS IS ${_defaultRadius}");

          bool interestCategoryMatches = stringInterests
              .any((interest) => activity.category.contains(interest));
          if (isWithinMaxDistance && interestCategoryMatches) {
            tempActivities.add(activity);
          }
        }
      });

      print("NUMBER OF TEMPACTIVITES IS ${tempActivities.length}");
      tempActivities.forEach((activity) => print(activity.activityName));

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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  TimeOfDay _convertToTimeOfDay(Map<String, dynamic> timeMap) {
    int hour = timeMap['hour'];
    int minute = timeMap['minute'];
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<Package> generatePackages(List<Activity> activities, int numberOfDays) {
    List<Package> packages = [];
    int packageDuration = 0;
    Package currentPackage = Package(activities: []);
    print('===========================================================');
    print('PACKAGE DURATION IS ${packageDuration}');
    print("NUMBER OF ACTIVITIES IS ${activities.length}");
    activities.forEach((activity) => print(activity.activityName));
    print('===========================================================');

    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      int totalDuration = currentPackage.totalDuration + activity.duration;
      packageDuration = packageDuration + totalDuration;

      print('TOTAL DURATION IS ${packageDuration}');

      if (totalDuration <= (numberOfDays * 600)) {
        currentPackage.activities.add(activity);
      } else {
        packages.add(currentPackage);
        currentPackage = Package(activities: [activity]);
      }
    }

    if (currentPackage.activities.isNotEmpty) {
      packages.add(currentPackage);
    }

    if (activities.length > 0) {
      setState(() {
        hasActivities = true;
      });
    }

    fetchedActivities = activities;

    return packages;
  }
}

class Activity {
  final String activityName;
  final String category;
  final String address;
  TimeOfDay timeStart;
  TimeOfDay timeEnd;
  double lat;
  double lon;
  final int duration;

  Activity({
    required this.activityName,
    required this.category,
    required this.address,
    required this.lat,
    required this.lon,
    required this.timeStart,
    required this.timeEnd,
    required this.duration,
  });

  Map<String, dynamic> toMap(BuildContext context) {
    return {
      'activityName': activityName,
      'category': category,
      'address': address,
      'lat': lat,
      'long': lon,
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
      lat: map['lat'],
      lon: map['long'],
      timeStart: TimeOfDay.fromDateTime(
        DateFormat("h:mm a").parse(map['timeStart']),
      ),
      timeEnd: TimeOfDay.fromDateTime(
        DateFormat("h:mm a").parse(map['timeEnd']),
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
