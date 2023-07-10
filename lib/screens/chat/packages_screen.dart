import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/models/models.dart';
import 'package:travel_mate/screens/chat/packageDetails_screen.dart';

class PackagesScreen extends StatelessWidget {
  final int numberOfDays;
  final Match match;

  PackagesScreen({required this.numberOfDays, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Itineraries'),
      ),
      body: FutureBuilder<List<Package>>(
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
                return Card(
                  child: ListTile(
                    title: Text('Package ${index + 1}'),
                    subtitle: Text(
                        'Total Duration: ${package.totalDuration} minutes'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PackageDetailsScreen(
                                  package: package,
                                  numberOfDays: numberOfDays,
                                  match: match,
                                )),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
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

        // Check if activity with same activityName and address already exists in activities list
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

    print('THIS IS SORTED');
    activities.forEach((act) => print(act.activityName));

    return generatePackages(activities, numberOfDays);
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
