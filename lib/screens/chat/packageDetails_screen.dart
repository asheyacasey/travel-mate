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
import 'package:unicons/unicons.dart';
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AuthBloc(
        databaseRepository: context.read<DatabaseRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),

      child: Scaffold(
     //  extendBodyBehindAppBar: true,
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
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0.0,
          actions: [
            IconButton(
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
                                  (widget.numberOfDays * 600 )) {
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
              icon: Icon(UniconsLine.book_medical),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  height: 240,
                  //width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                    fit: BoxFit.cover,
                      image: AssetImage('assets/ph-cover-photo.png'),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                 // color: Colors.blue,
                  height: 500,
                  child: ListView.builder(

                    itemCount: activitiesByDay.length,
                    itemBuilder: (context, dayIndex) {
                      List<Activity> activities = activitiesByDay[dayIndex];
                      int dayNumber = dayIndex + 1;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:  Color(0xFFF5C518),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Day $dayNumber',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: ListView.builder(
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
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(

                                          child: Text(
                                            activity.activityName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${activity.address}',
                                          style: TextStyle(
                                            fontSize: 14
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFB0DB2D),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            '${activity.category}',
                                            style: TextStyle(
                                                fontSize: 14
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),


                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        persistentFooterButtons: [
          TextButton(
            onPressed: () => sendItinerary(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Color(0xFFB0DB2D),
              minimumSize: Size(double.infinity, 55.0),
            ),
            child: Container(
              width: double.infinity,
              child: Text(
                'Send Itinerary Plan',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void sendItinerary(BuildContext context) async {
    try {
      final String name = context.read<AuthBloc>().state.user!.name;
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
          message: "${name} sent an Invitation",
          numberOfDays: widget.numberOfDays,
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

      if (totalDuration + activityDuration > 600 ||
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
