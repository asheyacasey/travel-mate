import 'package:cloud_firestore/cloud_firestore.dart';
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

// class PackageDetailsScreen extends StatelessWidget {
//   final Package package;

//   PackageDetailsScreen({required this.package});

//   @override
//   Widget build(BuildContext context) {
//     List<List<Activity>> activitiesByDay =
//         groupActivitiesByDay(package.activities);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Package Details'),
//       ),
//       body: ListView.builder(
//         itemCount: activitiesByDay.length,
//         itemBuilder: (context, dayIndex) {
//           List<Activity> activities = activitiesByDay[dayIndex];
//           int dayNumber = dayIndex + 1;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   'Day $dayNumber',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: activities.length,
//                 itemBuilder: (context, index) {
//                   Activity activity = activities[index];
//                   return ListTile(
//                     title: Text(activity.activityName),
//                     subtitle: Text(
//                       'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   List<List<Activity>> groupActivitiesByDay(List<Activity> activities) {
//     List<List<Activity>> activitiesByDay = [];
//     List<Activity> currentDayActivities = [];

//     activities.sort((a, b) {
//       DateTime dateTimeA = DateTime(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//         a.timeStart.hour,
//         a.timeStart.minute,
//       );
//       DateTime dateTimeB = DateTime(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//         b.timeStart.hour,
//         b.timeStart.minute,
//       );

//       int timeComparison = dateTimeA.compareTo(dateTimeB);
//       if (timeComparison != 0) {
//         return timeComparison; // Sort by timeStart
//       } else {
//         return a.duration
//             .compareTo(b.duration); // Sort by duration (secondary criteria)
//       }
//     });

//     int totalDuration = 0;
//     for (int i = 0; i < activities.length; i++) {
//       Activity activity = activities[i];
//       totalDuration += activity.duration;
//       currentDayActivities.add(activity);

//       if (totalDuration >= 180 || i == activities.length - 1) {
//         currentDayActivities.sort((a, b) {
//           DateTime dateTimeA = DateTime(
//             DateTime.now().year,
//             DateTime.now().month,
//             DateTime.now().day,
//             a.timeStart.hour,
//             a.timeStart.minute,
//           );
//           DateTime dateTimeB = DateTime(
//             DateTime.now().year,
//             DateTime.now().month,
//             DateTime.now().day,
//             b.timeStart.hour,
//             b.timeStart.minute,
//           );

//           int timeComparison = dateTimeA.compareTo(dateTimeB);
//           if (timeComparison != 0) {
//             return timeComparison; // Sort by timeStart
//           } else {
//             return a.duration
//                 .compareTo(b.duration); // Sort by duration (secondary criteria)
//           }
//         });

//         activitiesByDay.add(currentDayActivities);
//         currentDayActivities = [];
//         totalDuration = 0;
//       }
//     }

//     return activitiesByDay;
//   }
// }

class PackageDetailsScreen extends StatefulWidget {
  final Package package;
  final int numberOfDays;

  PackageDetailsScreen({required this.package, required this.numberOfDays});

  @override
  _PackageDetailsScreenState createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  List<List<Activity>> activitiesByDay = [];
  List<Activity> availableActivities = [];

  @override
  void initState() {
    super.initState();
    fetchActivitiesFromFirebase();
    activitiesByDay = groupActivitiesByDay(widget.package.activities);
  }

  Future<void> fetchActivitiesFromFirebase() async {
    List<Activity> activities = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('business').get();

    snapshot.docs.forEach((doc) {
      List<dynamic> activityList = doc['activities'];

      activityList.forEach((activityData) {
        String activityName = activityData['name'];
        String category = activityData['category'];
        String address = activityData['address'];
        TimeOfDay timeStart = _convertToTimeOfDay(activityData['startTime']);
        TimeOfDay timeEnd = _convertToTimeOfDay(activityData['endTime']);
        int duration = activityData['duration'];

        Activity activity = Activity(
          activityName: activityName,
          category: category,
          address: address,
          timeStart: timeStart,
          timeEnd: timeEnd,
          duration: duration,
        );

        // Check if the activity is already in the itinerary
        bool isActivityInItinerary = widget.package.activities.any(
            (itineraryActivity) =>
                itineraryActivity.activityName == activity.activityName &&
                itineraryActivity.address == activity.address);

        // Add the activity to the list only if it is not already in the itinerary
        if (!isActivityInItinerary) {
          activities.add(activity);
        }
      });
    });

    setState(() {
      availableActivities = activities;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  return Dismissible(
                    key: Key(activity.activityName),
                    onDismissed: (direction) {
                      setState(() {
                        widget.package.activities.remove(activity);
                        activitiesByDay =
                            groupActivitiesByDay(widget.package.activities);
                      });
                      fetchActivitiesFromFirebase();
                    },
                    child: ListTile(
                      title: Text(activity.activityName),
                      subtitle: Text(
                        'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Activity'),
              content: DropdownButton<Activity>(
                items: [
                  DropdownMenuItem<Activity>(
                    value: null,
                    child: Text('Select an activity'), // Placeholder text
                  ),
                  ...availableActivities.map((activity) {
                    return DropdownMenuItem<Activity>(
                      value: activity,
                      child: Column(
                        children: [
                          Text(activity.activityName),
                          Text(
                            'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (selectedActivity) {
                  if (selectedActivity != null) {
                    int currentDuration = widget.package.activities.fold(
                      0,
                      (previousValue, activity) =>
                          previousValue + activity.duration,
                    );
                    if (currentDuration + selectedActivity.duration >
                        (widget.numberOfDays * 180)) {
                      showMessage(
                          'Adding this activity will exceed the total duration.');
                    } else {
                      setState(() {
                        widget.package.activities.add(selectedActivity);
                        widget.package.activities.sort((a, b) {
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
                            return timeComparison; // Sort by timeStart
                          } else {
                            return a.duration.compareTo(b
                                .duration); // Sort by duration (secondary criteria)
                          }
                        });
                        activitiesByDay =
                            groupActivitiesByDay(widget.package.activities);
                        availableActivities.remove(selectedActivity);
                      });
                      Navigator.pop(context); // Close the dialog
                    }
                  }
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<List<Activity>> groupActivitiesByDay(List<Activity> activities) {
    List<List<Activity>> activitiesByDay = [];
    List<Activity> currentDayActivities = [];

    DateTime currentDay = DateTime.now();
    int totalDuration = 0;
    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];
      DateTime activityDateTime = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day,
        activity.timeStart.hour,
        activity.timeStart.minute,
      );

      int activityDuration = activity.duration;

      if (totalDuration + activityDuration > 180 ||
          activityDateTime.difference(currentDay).inDays > 0) {
        activitiesByDay.add(currentDayActivities);
        currentDayActivities = [];
        totalDuration = 0;
      }

      currentDayActivities.add(activity);
      totalDuration += activityDuration;
      currentDay = activityDateTime;
    }

    if (currentDayActivities.isNotEmpty) {
      activitiesByDay.add(currentDayActivities);
    }

    return activitiesByDay;
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Warning'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
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

TimeOfDay _convertToTimeOfDay(Map<String, dynamic> timeMap) {
  int hour = timeMap['hour'];
  int minute = timeMap['minute'];
  return TimeOfDay(hour: hour, minute: minute);
}
