import 'package:flutter/material.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';

class ItineraryScreen extends StatelessWidget {
  final Map<String, dynamic>? itinerary;

  const ItineraryScreen({Key? key, required this.itinerary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> activitiesData = itinerary?['activities'] ?? [];

    // Convert activitiesData into List<Activity>
    final List<Activity> activities = activitiesData.map((data) {
      return Activity.fromFirebaseMap(data, context);
    }).toList();

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
        return timeComparison; // Sort by timeStart
      } else {
        return a.duration
            .compareTo(b.duration); // Sort by duration (secondary criteria)
      }
    });

    // Group the activities by day
    final List<List<Activity>> activitiesByDay =
        groupActivitiesByDay(activities);

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary'),
      ),
      body: ListView.builder(
        itemCount: activitiesByDay.length,
        itemBuilder: (context, dayIndex) {
          final List<Activity> dayActivities = activitiesByDay[dayIndex];
          final int dayNumber = dayIndex + 1;

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
                itemCount: dayActivities.length,
                itemBuilder: (context, index) {
                  final Activity activity = dayActivities[index];

                  return ListTile(
                    title: Text(activity.activityName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${activity.category}'),
                        Text('Address: ${activity.address}'),
                        Text('Duration: ${activity.duration} mins'),
                        Text(
                            'Time Start: ${activity.timeStart.format(context)}'),
                        Text('Time End: ${activity.timeEnd.format(context)}'),
                      ],
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

    DateTime currentDay = DateTime.now();
    int totalDuration = 0;

    for (int i = 0; i < activities.length; i++) {
      final Activity activity = activities[i];

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
}
