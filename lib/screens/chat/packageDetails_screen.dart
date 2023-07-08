import 'package:flutter/material.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';

// class PackageDetailsScreen extends StatelessWidget {
//   final Package package;

//   PackageDetailsScreen({required this.package});

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> dayWidgets = [];
//     List<Activity> activities = package.activities;

//     int totalDuration = 0;
//     int currentDay = 1;

//     for (int i = 0; i < activities.length; i++) {
//       Activity activity = activities[i];
//       totalDuration += activity.duration;

//       if (totalDuration > 180) {
//         currentDay++;
//         totalDuration = activity.duration;
//       }

//       String dayTitle = 'Day $currentDay';

//       if (!dayWidgets.contains(dayTitle)) {
//         dayWidgets.add(
//           Text(
//             dayTitle,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         );
//       }

//       dayWidgets.add(
//         ListTile(
//           title: Text(activity.activityName),
//           subtitle: Text(
//             'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Package Details'),
//       ),
//       body: ListView(children: dayWidgets),
//     );
//   }
// }

class PackageDetailsScreen extends StatelessWidget {
  final Package package;

  PackageDetailsScreen({required this.package});

  @override
  Widget build(BuildContext context) {
    List<List<Activity>> activitiesByDay =
        groupActivitiesByDay(package.activities);

    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: ListView.builder(
        itemCount: activitiesByDay.length,
        itemBuilder: (context, dayIndex) {
          List<Activity> activities = activitiesByDay[dayIndex];
          int dayNumber = dayIndex + 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Day $dayNumber',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  Activity activity = activities[index];
                  return ListTile(
                    title: Text(activity.activityName),
                    subtitle: Text(
                      'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<List<Activity>> groupActivitiesByDay(List<Activity> activities) {
    List<List<Activity>> activitiesByDay = [];
    List<Activity> currentDayActivities = [];

    int totalDuration = 0;
    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      totalDuration += activity.duration;
      currentDayActivities.add(activity);

      if (totalDuration >= 180 || i == activities.length - 1) {
        activitiesByDay.add(currentDayActivities);
        currentDayActivities = [];
        totalDuration = 0;
      }
    }

    return activitiesByDay;
  }
}

TimeOfDay addDurationToTime(TimeOfDay time, int duration) {
  int newMinute = time.minute + duration;
  int newHour = time.hour + (newMinute ~/ 60);
  newMinute = newMinute % 60;

  return TimeOfDay(hour: newHour, minute: newMinute);
}
