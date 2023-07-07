// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_picker/flutter_picker.dart';

// class BusinessHomeScreen extends StatefulWidget {
//   const BusinessHomeScreen({Key? key}) : super(key: key);

//   @override
//   _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
// }

// class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   int? _duration;
//   String businessName = '';
//   List<Activity> activities = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchBusinessName();
//     _fetchActivities();
//   }

//   set startTime(TimeOfDay? value) {
//     setState(() {
//       _startTime = value;
//     });
//   }

//   set endTime(TimeOfDay? value) {
//     setState(() {
//       _endTime = value;
//     });
//   }

//   set duration(int? value) {
//     setState(() {
//       _duration = value;
//     });
//   }

//   int? get duration => _duration;
//   TimeOfDay? get startTime => _startTime;
//   TimeOfDay? get endTime => _endTime;

//   void resetTime() {
//     setState(() {
//       _startTime = null;
//       _endTime = null;
//       _duration = null;
//     });
//   }

//   Future<void> _fetchBusinessName() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('business')
//           .doc(user.uid)
//           .get();
//       setState(() {
//         businessName = snapshot.get('businessName') ?? '';
//       });
//     }
//   }

//   Future<void> _fetchActivities() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('business')
//           .doc(user.uid)
//           .get();
//       if (snapshot.exists) {
//         List<dynamic> activitiesData = snapshot.get('activities') ?? [];
//         setState(() {
//           activities =
//               activitiesData.map((data) => Activity.fromMap(data)).toList();
//         });
//       } else {
//         setState(() {
//           activities = [];
//         });
//       }
//     }
//   }

//   Future<void> _addActivity(Activity activity) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection('business').doc(user.uid);

//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(docRef);
//         List<dynamic> activitiesData = snapshot.get('activities') ?? [];
//         activitiesData.add(activity.toMap());
//         transaction.update(docRef, {'activities': activitiesData});
//       });

//       setState(() {
//         activities.add(activity);
//       });
//     }
//   }

//   Future<void> _updateActivity(Activity activity) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection('business').doc(user.uid);

//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(docRef);
//         List<dynamic> activitiesData = snapshot.get('activities') ?? [];
//         int index = activities.indexWhere((a) => a.id == activity.id);
//         if (index != -1) {
//           activitiesData[index] = activity.toMap();
//           transaction.update(docRef, {'activities': activitiesData});
//           setState(() {
//             activities[index] = activity;
//           });
//         }
//       });
//     }
//   }

//   Future<void> _deleteActivity(Activity activity) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection('business').doc(user.uid);

//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(docRef);
//         List<dynamic> activitiesData = snapshot.get('activities') ?? [];
//         activitiesData.removeWhere((data) => data['id'] == activity.id);
//         transaction.update(docRef, {'activities': activitiesData});
//         setState(() {
//           activities.remove(activity);
//         });
//       });
//     }
//   }

//   Future<void> _showAddActivityDialog(BuildContext context) async {
//     TextEditingController nameController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Activity'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Activity Name'),
//               ),
//               SizedBox(height: 16),
//               Text('Start Time'),
//               InkWell(
//                 onTap: () async {
//                   TimeOfDay? selectedTime = await showTimePicker(
//                     context: context,
//                     initialTime: startTime ?? TimeOfDay.now(),
//                   );
//                   if (selectedTime != null) {
//                     setState(() {
//                       startTime = selectedTime;
//                     });
//                     print("Start ISSSSSS" + startTime!.format(context));
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: startTime != null
//                       ? Text('${startTime!.format(context)}')
//                       : Text('Select start time'),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text('End Time'),
//               InkWell(
//                 onTap: () async {
//                   TimeOfDay? selectedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (selectedTime != null) {
//                     setState(() {
//                       endTime = selectedTime;
//                     });
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: endTime != null
//                       ? Text('${endTime!.format(context)}')
//                       : Text('Select end time'),
//                 ),
//               ),
//               SizedBox(height: 16),
//               InkWell(
//                 onTap: () {
//                   Picker(
//                     adapter: NumberPickerAdapter(data: [
//                       NumberPickerColumn(
//                         begin: 5,
//                         end: 120,
//                         initValue: duration ?? 15,
//                         suffix: Text(' min'),
//                       )
//                     ]),
//                     hideHeader: true,
//                     title: Text('Select Duration'),
//                     onConfirm: (Picker picker, List<int> value) {
//                       setState(() {
//                         duration = picker.getSelectedValues()[0];
//                       });
//                     },
//                   ).showDialog(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: duration != null
//                       ? Text('$duration min')
//                       : Text('Select duration'),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (startTime != null && endTime != null && duration != null) {
//                   String name = nameController.text.trim();
//                   if (name.isNotEmpty) {
//                     Activity activity = Activity(
//                       id: DateTime.now().millisecondsSinceEpoch.toString(),
//                       name: name,
//                       startTime: startTime!,
//                       endTime: endTime!,
//                       duration: duration!,
//                     );
//                     await _addActivity(activity);
//                     print(nameController);
//                     print(startTime);
//                     print(endTime);
//                     print(duration);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _showEditActivityDialog(
//       BuildContext context, Activity activity) async {
//     TextEditingController nameController =
//         TextEditingController(text: activity.name);
//     TimeOfDay? startTime = activity.startTime;
//     TimeOfDay? endTime = activity.endTime;
//     int? duration = activity.duration;

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Activity'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Activity Name'),
//               ),
//               SizedBox(height: 16),
//               Text('Start Time'),
//               InkWell(
//                 onTap: () async {
//                   TimeOfDay? selectedTime = await showTimePicker(
//                     context: context,
//                     initialTime: endTime ?? TimeOfDay.now(),
//                   );
//                   if (selectedTime != null) {
//                     setState(() {
//                       endTime = selectedTime;
//                     });
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: endTime != null
//                       ? Text('${endTime!.format(context)}')
//                       : Text('Select end time'),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text('End Time'),
//               InkWell(
//                 onTap: () async {
//                   TimeOfDay? selectedTime = await showTimePicker(
//                     context: context,
//                     initialTime: endTime!,
//                   );
//                   if (selectedTime != null) {
//                     setState(() {
//                       endTime = selectedTime;
//                     });
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: endTime != null
//                       ? Text('${endTime!.format(context)}')
//                       : Text('Select end time'),
//                 ),
//               ),
//               SizedBox(height: 16),
//               InkWell(
//                 onTap: () {
//                   Picker(
//                     adapter: NumberPickerAdapter(data: [
//                       NumberPickerColumn(
//                         begin: 5,
//                         end: 120,
//                         initValue: duration ?? 15,
//                         suffix: Text(' min'),
//                       )
//                     ]),
//                     hideHeader: true,
//                     title: Text('Select Duration'),
//                     onConfirm: (Picker picker, List<int> value) {
//                       setState(() {
//                         duration = picker.getSelectedValues()[0];
//                       });
//                     },
//                   ).showDialog(context);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: duration != null
//                       ? Text('$duration min')
//                       : Text('Select duration'),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (startTime != null && endTime != null && duration != null) {
//                   String name = nameController.text.trim();
//                   if (name.isNotEmpty) {
//                     Activity updatedActivity = Activity(
//                       id: activity.id,
//                       name: name,
//                       startTime: startTime!,
//                       endTime: endTime!,
//                       duration: duration!,
//                     );
//                     await _updateActivity(updatedActivity);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 16),
//           Text(
//             'Welcome, $businessName!',
//             style: TextStyle(fontSize: 24),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => _showAddActivityDialog(context),
//             child: Text('Add Activity'),
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: activities.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Activity activity = activities[index];
//                 return ListTile(
//                   title: Text(activity.name),
//                   subtitle: Text(
//                       '${activity.startTime.format(context)} - ${activity.endTime.format(context)} (${activity.duration} min)'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () => _showEditActivityDialog(context, activity),
//                   ),
//                   onTap: () => _deleteActivity(activity),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Activity {
//   final String id;
//   final String name;
//   final TimeOfDay startTime;
//   final TimeOfDay endTime;
//   final int duration;

//   Activity({
//     required this.id,
//     required this.name,
//     required this.startTime,
//     required this.endTime,
//     required this.duration,
//   });

//   factory Activity.fromMap(Map<String, dynamic> map) {
//     return Activity(
//       id: map['id'],
//       name: map['name'],
//       startTime: TimeOfDay(
//         hour: map['startTime']['hour'],
//         minute: map['startTime']['minute'],
//       ),
//       endTime: TimeOfDay(
//         hour: map['endTime']['hour'],
//         minute: map['endTime']['minute'],
//       ),
//       duration: map['duration'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'startTime': {
//         'hour': startTime.hour,
//         'minute': startTime.minute,
//       },
//       'endTime': {
//         'hour': endTime.hour,
//         'minute': endTime.minute,
//       },
//       'duration': duration,
//     };
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/business/screens/business_addActivity.dart';
import 'package:travel_mate/business/screens/business_editActivity.dart';
import 'package:travel_mate/business/screens/business_login.dart';

class BusinessHomeScreen extends StatefulWidget {
  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? activitiesStream;
  User? user = FirebaseAuth.instance.currentUser;
  List<Activity> activities = [];
  String businessName = '';

  Future<void> _fetchBusinessName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('business')
          .doc(user.uid)
          .get();
      setState(() {
        businessName = snapshot.get('businessName') ?? '';
      });
    }
  }

  Future<void> _fetchActivities() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('business')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        List<dynamic> activitiesData = snapshot.get('activities') ?? [];
        setState(() {
          activities =
              activitiesData.map((data) => Activity.fromMap(data)).toList();
        });
      } else {
        setState(() {
          activities = [];
        });
      }
    }
  }

  Future<void> _deleteActivity(Activity activity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('business').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        List<dynamic> activitiesData = snapshot.get('activities') ?? [];
        activitiesData.removeWhere((data) => data['id'] == activity.id);
        transaction.update(docRef, {'activities': activitiesData});
        setState(() {
          activities.remove(activity);
        });
      });
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BusinessLogin()),
      );
    } catch (e) {
      print('Error logging out: $e');
      // Handle any errors that occur during logout
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBusinessName();
    _fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text('Welcome $businessName',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        ),

        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),

      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];

              return ListTile(
                title: Text(
                  activity.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Category: ${activity.category}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Start Time: ${activity.startTime.format(context)} - End Time: ${activity.endTime.format(context)}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Duration: ${activity.duration} min',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Location: ${activity.address}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditActivityScreen(
                          onActivityEdited: _fetchActivities,
                          activity: activity,
                        ),
                      ),
                    );
                  },
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Delete Activity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Are you sure you want to delete this activity?',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(width: 8),
                                TextButton(
                                  onPressed: () async {
                                    await _deleteActivity(activity);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add new activity screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewActivityScreen(
                onActivityAdded: _fetchActivities,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Activity {
  final String id;
  final String name;
  final String address;
  final String category;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int duration;

  Activity({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      category: map['category'],
      startTime: TimeOfDay(
        hour: map['startTime']['hour'],
        minute: map['startTime']['minute'],
      ),
      endTime: TimeOfDay(
        hour: map['endTime']['hour'],
        minute: map['endTime']['minute'],
      ),
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'category': category,
      'startTime': {
        'hour': startTime.hour,
        'minute': startTime.minute,
      },
      'endTime': {
        'hour': endTime.hour,
        'minute': endTime.minute,
      },
      'duration': duration,
    };
  }
}
