import 'package:flutter/material.dart';

class PackageDetailsScreen extends StatelessWidget {
  final Package package;

  PackageDetailsScreen({required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: ListView.builder(
        itemCount: package.activities.length,
        itemBuilder: (context, index) {
          Activity activity = package.activities[index];
          return ListTile(
            title: Text(activity.activityName),
            subtitle: Text(
                'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}'),
          );
        },
      ),
    );
  }
}

TimeOfDay addDurationToTime(TimeOfDay time, int duration) {
  int newMinute = time.minute + duration;
  int newHour = time.hour + (newMinute ~/ 60);
  newMinute = newMinute % 60;

  return TimeOfDay(hour: newHour, minute: newMinute);
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
