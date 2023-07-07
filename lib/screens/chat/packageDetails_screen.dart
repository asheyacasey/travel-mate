import 'package:flutter/material.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';

class PackageDetailsScreen extends StatelessWidget {
  final Package package;

  PackageDetailsScreen({required this.package});

  @override
  Widget build(BuildContext context) {
    List<Widget> dayWidgets = [];
    List<Activity> activities = package.activities;

    int totalDuration = 0;
    int currentDay = 1;

    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      totalDuration += activity.duration;

      if (totalDuration > 120) {
        currentDay++;
        totalDuration = activity.duration;
      }

      String dayTitle = 'Day $currentDay';

      if (!dayWidgets.contains(dayTitle)) {
        dayWidgets.add(
          Text(
            dayTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }

      dayWidgets.add(
        ListTile(
          title: Text(activity.activityName),
          subtitle: Text(
            'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: ListView(children: dayWidgets),
    );
  }
}

TimeOfDay addDurationToTime(TimeOfDay time, int duration) {
  int newMinute = time.minute + duration;
  int newHour = time.hour + (newMinute ~/ 60);
  newMinute = newMinute % 60;

  return TimeOfDay(hour: newHour, minute: newMinute);
}
