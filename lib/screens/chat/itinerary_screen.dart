import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:travel_mate/blocs/blocs.dart';
import 'package:travel_mate/repositories/auth/auth_repository.dart';
import 'package:travel_mate/repositories/database/database_repository.dart';
import 'package:travel_mate/screens/chat/packages_screen.dart';
import 'package:travel_mate/models/models.dart';
import 'package:uuid/uuid.dart';

class ItineraryScreen extends StatefulWidget {
  final int? numberOfDays;
  final Map<String, dynamic>? itinerary;
  final Match? match;
  final String? oldMessageId;

  ItineraryScreen(
      {required this.numberOfDays,
      this.itinerary,
      this.match,
      this.oldMessageId});

  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  List<List<Activity>> activitiesByDay = [];
  List<Activity> availableActivities = [];
  List<Activity> transformedActivities = [];

  @override
  void initState() {
    super.initState();
    transformIntoActivity();
    fetchActivitiesFromFirebase();
  }

  void transformIntoActivity() {
    final List<dynamic> activitiesData = widget.itinerary?['activities'] ?? [];

    // Convert activitiesData into List<Activity>
    final List<Activity> activities = activitiesData.map((data) {
      return Activity.fromFirebaseMap(data, context);
    }).toList();

    transformedActivities = activities;
    activitiesByDay = groupActivitiesByDay(activities);
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
        bool isActivityInItinerary = transformedActivities.any(
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
      create: (context) => AuthBloc(
        databaseRepository: context.read<DatabaseRepository>(),
        authRepository: context.read<AuthRepository>(),
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
                          transformedActivities.remove(activity);
                          activitiesByDay =
                              groupActivitiesByDay(transformedActivities);
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
                          int currentDuration = transformedActivities.fold(
                            0,
                            (previousValue, activity) =>
                                previousValue + activity.duration,
                          );
                          if (currentDuration + activity.duration >
                              (widget.numberOfDays! * 180)) {
                            showMessage(
                                'Adding this activity will exceed the total duration.');
                          } else {
                            setState(() {
                              transformedActivities.add(activity);
                              transformedActivities.sort((a, b) {
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
                              activitiesByDay =
                                  groupActivitiesByDay(transformedActivities);
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
            onPressed: () => updateItinerary(context),
            child: Text('Update Itinerary'),
          ),
        ],
      ),
    );
  }

  void updateItinerary(BuildContext context) async {
    try {
      final String name = context.read<AuthBloc>().state.user!.name;
      List<Activity> itinerary = transformedActivities;
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

      DocumentReference docRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.match!.chat.id);

      try {
        DocumentSnapshot doc = await docRef.get();

        if (doc.exists) {
          // Retrieve the array from the document
          List<dynamic> chatsArray = doc.get('messages');

          // Find the index of the element with matching messageId
          int indexToDelete = chatsArray
              .indexWhere((chat) => chat['messageId'] == widget.oldMessageId);

          if (indexToDelete != -1) {
            // Remove the element from the array
            chatsArray.removeAt(indexToDelete);

            // Update the document with the modified array
            await docRef.update({'messages': chatsArray});
            print('Element deleted successfully.');
          } else {
            print('Element not found in the array.');
          }
        } else {
          print('Document not found.');
        }
      } catch (error) {
        print('Error retrieving or updating document: $error');
      }

      final Message message = Message(
          senderId: widget.match!.userId,
          receiverId: widget.match!.matchUser.id!,
          messageId: messageId,
          message: "${name} updated the Itinerary",
          numberOfDays: widget.numberOfDays,
          itinerary: itineraryMap,
          dateTime: DateTime.now(),
          timeString: DateFormat('HH:mm').format(DateTime.now()));

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.match!.chat.id)
          .update({
        'messages': FieldValue.arrayUnion([
          message.toJson(),
        ])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Itinerary successfully updated.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update itinerary.'),
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
