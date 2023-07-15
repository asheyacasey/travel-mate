import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';
import 'package:travel_mate/models/models.dart';
import 'package:uuid/uuid.dart';

class PackageDetailsScreen extends StatefulWidget {
  final Package package;
  final int numberOfDays;
  final Match match;

  PackageDetailsScreen(
      {required this.package, required this.numberOfDays, required this.match});

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

        //Check if the activity is a duplicate
        bool activityExists = activities.any((existingActivity) =>
            existingActivity.activityName == activity.activityName &&
            existingActivity.address == activity.address);

        // Add the activity to the list only if it is not already in the itinerary
        if (!isActivityInItinerary && !activityExists) {
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
    return BlocProvider(
      create: (context) => ChatBloc(
        databaseRepository: context.read<DatabaseRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'travelmate',
            style: GoogleFonts.fredokaOne(
              textStyle: TextStyle(
                fontSize: 20,
                color: Color(0xFFB0DB2D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0.0,
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
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    itemCount: availableActivities.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Text('Select an activity'); // Placeholder text
                      }
                      final activity = availableActivities[index - 1];
                      return ListTile(
                        title: Text(activity.activityName),
                        subtitle: Text(
                          'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
                        ),
                        onTap: () {
                          int currentDuration = widget.package.activities.fold(
                            0,
                            (previousValue, activity) =>
                                previousValue + activity.duration,
                          );
                          if (currentDuration + activity.duration >
                              (widget.numberOfDays * 180)) {
                            showMessage(
                                'Adding this activity will exceed the total duration.');
                          } else {
                            setState(() {
                              widget.package.activities.add(activity);
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

                                int timeComparison =
                                    dateTimeA.compareTo(dateTimeB);
                                if (timeComparison != 0) {
                                  return timeComparison; // Sort by timeStart
                                } else {
                                  return a.duration.compareTo(b
                                      .duration); // Sort by duration (secondary criteria)
                                }
                              });
                              activitiesByDay = groupActivitiesByDay(
                                  widget.package.activities);
                              availableActivities.remove(activity);
                            });
                            Navigator.pop(context); // Close the dialog
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () => sendItinerary(context),
            child: Text('Send Itinerary'),
          ),
        ],
      ),
    );
  }

  void sendItinerary(BuildContext context) async {
    try {
      List<Activity> itinerary = widget.package.activities;
      String messageId = Uuid().v4();

      List<Activity> updatedItinerary = [];

      itinerary.forEach((activity) {
        int minutes = activity.timeStart.minute + activity.duration;
        int hours = activity.timeStart.hour + (minutes ~/ 60);
        int remainingMinutes = minutes % 60;

        TimeOfDay updatedTimeEnd =
            TimeOfDay(hour: hours, minute: remainingMinutes);

        Activity updatedActivity = Activity(
          activityName: activity.activityName,
          category: activity.category,
          address: activity.address,
          timeStart: activity.timeStart,
          timeEnd: updatedTimeEnd, // Update the timeEnd value
          duration: activity.duration,
        );

        updatedItinerary.add(updatedActivity);
      });

      Map<String, dynamic> itineraryMap = {
        'activities': updatedItinerary
            .map((activity) => activity.toMap(context))
            .toList(),
      };

      final Message message = Message(
          senderId: widget.match.userId,
          receiverId: widget.match.matchUser.id!,
          messageId: messageId,
          message: "Date Invitation",
          itinerary: itineraryMap,
          dateTime: DateTime.now(),
          timeString: DateFormat('HH:mm').format(DateTime.now()));

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.match.chat.id)
          .update({
        'messages': FieldValue.arrayUnion([
          message.toJson(),
        ])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Itinerary successfully sent.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send itinerary.'),
        ),
      );
      print(error);
    }
  }

  List<List<Activity>> groupActivitiesByDay(List<Activity> activities) {
    List<List<Activity>> activitiesByDay = [];
    List<Activity> currentDayActivities = [];

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
