import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/screens/chat/packageDetails_screen.dart';

class PackagesScreen extends StatelessWidget {
  final int numberOfDays;

  PackagesScreen({required this.numberOfDays});

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
                            builder: (context) =>
                                PackageDetailsScreen(package: package)),
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
    snapshot.docs.forEach((doc) {
      List<dynamic> activityList = doc['activities'];
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
        activities.add(activity);
      });
    });

    return generatePackages(activities, numberOfDays);
  }

  TimeOfDay _convertToTimeOfDay(Map<String, dynamic> timeMap) {
    int hour = timeMap['hour'];
    int minute = timeMap['minute'];
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<Package> generatePackages(List<Activity> activities, int numberOfDays) {
    List<Package> packages = [];
    Package currentPackage = Package();

    activities.sort((a, b) {
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

    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      int totalDuration = currentPackage.totalDuration + activity.duration;

      if (totalDuration <= (numberOfDays * 120)) {
        currentPackage.activities.add(activity);
      } else {
        packages.add(currentPackage);
        currentPackage = Package();
        currentPackage.activities.add(activity);
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
