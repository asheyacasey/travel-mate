import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:flutter_xlider/flutter_xlider.dart';
import 'dart:math' as math;

class ItineraryScreen extends StatefulWidget {
  final int? numberOfDays;
  final Map<String, dynamic>? itinerary;
  final Match? match;
  final String? oldMessageId;
  final double? placeLat;
  final double? placeLon;
  final double? placeRadius;
  final User? currentUser;

  ItineraryScreen(
      {required this.numberOfDays,
      this.itinerary,
      this.match,
      this.oldMessageId,
      this.placeLat,
      this.placeLon,
      this.placeRadius,
      this.currentUser});

  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  List<List<Activity>> activitiesByDay = [];
  List<Activity> availableActivities = [];
  List<Activity> transformedActivities = [];
  double _defaultRadius = 0;

  @override
  void initState() {
    super.initState();
    _defaultRadius = widget.placeRadius!;
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

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  Future<void> fetchActivitiesFromFirebase() async {
    List<Activity> activities = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('business').get();

    double _mapRadius = _defaultRadius / 1000;

    List interests =
        widget.match!.matchUser.interests + widget.currentUser!.interests;

    List<String> stringInterests =
        interests.map((interest) => interest.toString()).toList();

    snapshot.docs.forEach((doc) {
      List<dynamic> activityList = doc['activities'];

      activityList.forEach((activityData) {
        String activityName = activityData['name'];
        String category = activityData['category'];
        String address = activityData['address'];
        double lat = activityData['lat'];
        double lon = activityData['long'];
        TimeOfDay timeStart = _convertToTimeOfDay(activityData['startTime']);
        TimeOfDay timeEnd = _convertToTimeOfDay(activityData['endTime']);
        int duration = activityData['duration'];

        Activity activity = Activity(
          activityName: activityName,
          category: category,
          address: address,
          lat: lat,
          lon: lon,
          timeStart: timeStart,
          timeEnd: timeEnd,
          duration: duration,
        );

        // Check if the activity is already in the itinerary
        bool isActivityInItinerary = transformedActivities.any(
            (itineraryActivity) =>
                itineraryActivity.activityName == activity.activityName &&
                itineraryActivity.address == activity.address);

        if (!isActivityInItinerary) {
          // Calculate the distance between the inputted place and the location of the activity
          double distance = calculateDistance(
            widget.placeLat!,
            widget.placeLon!,
            activity.lat,
            activity.lon,
          );

          bool isWithinMaxDistance = distance <= _mapRadius;

          bool interestCategoryMatches = stringInterests
              .any((interest) => activity.category.contains(interest));

          if (isWithinMaxDistance && interestCategoryMatches) {
            activities.add(activity);
          }
        }
      });
    });

    setState(() {
      availableActivities = activities;
    });

    print('DEFAULT RADIUS IS ${_defaultRadius}');
    print('AVAILABLE ACTIVITIES ARE');
    print('NUMBER OF ACTIVITIES ${availableActivities.length}');
    availableActivities.forEach((element) {
      print(element.activityName);
    });
  }

  void _onRadiusChanged(int handlerIndex, lowerValue, upperValue) {
    setState(() {
      _defaultRadius = lowerValue;
    });
  }

  // Function to fetch activities again with the new radius and generate new packages.
  void _applyNewRadius() {
    availableActivities.clear();
    fetchActivitiesFromFirebase();
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
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Adjust Radius"),
                          FlutterSlider(
                            values: [_defaultRadius],
                            max:
                                100000.0, // Adjust the max value according to your requirement.
                            min:
                                1000.0, // Adjust the min value according to your requirement.
                            step: FlutterSliderStep(
                                step:
                                    10000.0), // Adjust the step value according to your requirement.
                            onDragging: _onRadiusChanged,
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBar: BoxDecoration(
                                color: Colors
                                    .blue, // Customize the color of the active part of the Slider
                              ),
                              inactiveTrackBar: BoxDecoration(
                                color: Colors
                                    .grey, // Customize the color of the inactive part of the Slider
                              ),
                            ),
                            handler: FlutterSliderHandler(
                              child: Icon(
                                Icons
                                    .circle, // Customize the appearance of the handler (dot/tick).
                                color: Colors
                                    .blue, // Customize the color of the handler (dot/tick).
                                size:
                                    20.0, // Customize the size of the handler (dot/tick).
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Apply the new radius when the button is clicked.
                              _applyNewRadius();
                              Navigator.of(context).pop();
                            },
                            child: Text("Apply Radius"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Add activity to itinerary plan',
                      style: GoogleFonts.fredokaOne(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF5C518), // First color
                        ),
                      ),
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: availableActivities.length,
                        itemBuilder: (context, index) {
                          final activity = availableActivities[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Set the border radius here
                                color: Color(0xFFF1F1F1),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    activity.activityName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${activity.address}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFB0DB2D),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          '${activity.category}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  int currentDuration =
                                      transformedActivities.fold(
                                    0,
                                    (previousValue, activity) =>
                                        previousValue + activity.duration,
                                  );
                                  if (currentDuration + activity.duration >
                                      (widget.numberOfDays! * 600)) {
                                    showMessage(
                                        'Adding this activity will exceed the total duration. Do you still want to continue?');
                                  } else {
                                    setState(() {
                                      activity.timeEnd =
                                          transformedActivities.last.timeEnd;
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
                                      activitiesByDay = groupActivitiesByDay(
                                          transformedActivities);
                                      availableActivities.remove(activity);
                                    });
                                    Navigator.pop(context); // Close the dialog
                                  }
                                },
                              ),
                            ),
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
                child: Expanded(
                  child: Container(
                    //    color: Colors.blue,
                    height: 500, // Replace with your desired background color
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
                                  color: Color(0xFFF5C518),
                                  borderRadius: BorderRadius.circular(
                                      15), // Add any desired border styling
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                        transformedActivities.remove(activity);
                                        activitiesByDay = groupActivitiesByDay(
                                            transformedActivities);
                                      });
                                      fetchActivitiesFromFirebase();
                                    },
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            '${activity.timeStart.format(context)} - ${activity.timeEnd.format(context)}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0, bottom: 2.0),
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                '${activity.address}',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFB0DB2D),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                '${activity.category}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
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
              ),
            ],
          ),
        ),

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //         title: Text('Add Activity'),
        //         content: Container(
        //           width: MediaQuery.of(context).size.width * 0.8,
        //           height: MediaQuery.of(context).size.height * 0.5,
        //           child: ListView.builder(
        //             itemCount: availableActivities.length + 1,
        //             itemBuilder: (context, index) {
        //               if (index == 0) {
        //                 return Text('Select an activity'); // Placeholder text
        //               }
        //               final activity = availableActivities[index - 1];
        //               return ListTile(
        //                 title: Text(activity.activityName),
        //                 subtitle: Text(
        //                   'Category: ${activity.category}\nAddress: ${activity.address}\nTime: ${activity.timeStart.format(context)} - ${addDurationToTime(activity.timeStart, activity.duration).format(context)}',
        //                 ),
        //                 onTap: () {
        //                   int currentDuration = transformedActivities.fold(
        //                     0,
        //                     (previousValue, activity) =>
        //                         previousValue + activity.duration,
        //                   );
        //                   if (currentDuration + activity.duration >
        //                       (widget.numberOfDays! * 600)) {
        //                     showMessage(
        //                         'Adding this activity will exceed the total duration.');
        //                   } else {
        //                     setState(() {
        //                       transformedActivities.add(activity);
        //                       transformedActivities.sort((a, b) {
        //                         DateTime dateTimeA = DateTime(
        //                           DateTime.now().year,
        //                           DateTime.now().month,
        //                           DateTime.now().day,
        //                           a.timeStart.hour,
        //                           a.timeStart.minute,
        //                         );
        //                         DateTime dateTimeB = DateTime(
        //                           DateTime.now().year,
        //                           DateTime.now().month,
        //                           DateTime.now().day,
        //                           b.timeStart.hour,
        //                           b.timeStart.minute,
        //                         );
        //
        //                         int timeComparison =
        //                             dateTimeA.compareTo(dateTimeB);
        //                         if (timeComparison != 0) {
        //                           return timeComparison; // Sort by timeStart
        //                         } else {
        //                           return a.duration.compareTo(b
        //                               .duration); // Sort by duration (secondary criteria)
        //                         }
        //                       });
        //                       activitiesByDay =
        //                           groupActivitiesByDay(transformedActivities);
        //                       availableActivities.remove(activity);
        //                     });
        //                     Navigator.pop(context); // Close the dialog
        //                   }
        //                 },
        //               );
        //             },
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        //   child: Icon(Icons.add),
        // ),
        persistentFooterButtons: [
          TextButton(
            onPressed: () => updateItinerary(context),
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
                'Update Itinerary',
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
          )
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
        Activity updatedActivity = Activity(
          activityName: activity.activityName,
          category: activity.category,
          address: activity.address,
          lat: activity.lat,
          lon: activity.lon,
          timeStart: activity.timeStart,
          timeEnd: activity.timeEnd, // Update the timeEnd value
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
          placeLat: widget.placeLat,
          placeLon: widget.placeLon,
          placeRadius: widget.placeRadius,
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

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Updated Itinerary Plan',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredokaOne(
              textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Color(0xFFF5C518), // First color
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/check-logo.png', // Replace this with the path to your image asset
                height: 120,
                width: 120,
              ),
              SizedBox(height: 10),
              Container(
                width: 180,
                child: Text(
                  'Your itinerary plan is successfully updated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Thank you for using TravelMate!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFFB0DB2D),
                  minimumSize: Size(120, 45),
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
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

    DateTime currentDay = DateTime.now();
    TimeOfDay nextActivityStart = TimeOfDay(hour: 7, minute: 0);
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
        // Check if new day is being set, update nextActivityStart to 7:00 AM
        nextActivityStart = TimeOfDay(hour: 7, minute: 0);

        activitiesByDay.add(currentDayActivities);
        currentDayActivities = [];
        totalDuration = 0;
      }

      // Set timeStart of activity to nextActivityStart
      activity.timeStart = nextActivityStart;

      // Calculate and set timeEnd based on timeStart and duration
      activity.timeEnd =
          calculateTimeEnd(activity.timeStart, activity.duration);

      currentDayActivities.add(activity);
      totalDuration += activityDuration;

      // Update nextActivityStart for the next iteration
      nextActivityStart = activity.timeEnd;
      currentDay = activityDateTime;
    }

    if (currentDayActivities.isNotEmpty) {
      activitiesByDay.add(currentDayActivities);
    }

    return activitiesByDay;
  }

  TimeOfDay calculateTimeEnd(TimeOfDay startTime, int duration) {
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = startMinutes + duration;

    int endHour = endMinutes ~/ 60;
    int endMinute = endMinutes % 60;

    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: AlertDialog(
          title: Text(
            'Hi Traveller,',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFF5C518),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.blue, // Custom button text color
                  fontSize: 18,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 8,
        ),
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
