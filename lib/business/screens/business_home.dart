import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_picker/flutter_picker.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  _BusinessHomeScreenState createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  String businessName = '';
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchBusinessName();
    _fetchActivities();
  }

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

  Future<void> _addActivity(Activity activity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('business').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        List<dynamic> activitiesData = snapshot.get('activities') ?? [];
        activitiesData.add(activity.toMap());
        transaction.update(docRef, {'activities': activitiesData});
      });

      setState(() {
        activities.add(activity);
      });
    }
  }

  Future<void> _updateActivity(Activity activity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('business').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        List<dynamic> activitiesData = snapshot.get('activities') ?? [];
        int index = activities.indexWhere((a) => a.id == activity.id);
        if (index != -1) {
          activitiesData[index] = activity.toMap();
          transaction.update(docRef, {'activities': activitiesData});
          setState(() {
            activities[index] = activity;
          });
        }
      });
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

  Future<void> _showAddActivityDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    int? duration;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Activity Name'),
              ),
              SizedBox(height: 16),
              Text('Start Time'),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      startTime = selectedTime;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: startTime != null
                      ? Text('${startTime!.format(context)}')
                      : Text('Select start time'),
                ),
              ),
              SizedBox(height: 16),
              Text('End Time'),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      endTime = selectedTime;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: endTime != null
                      ? Text('${endTime!.format(context)}')
                      : Text('Select end time'),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Picker(
                    adapter: NumberPickerAdapter(data: [
                      NumberPickerColumn(
                        begin: 5,
                        end: 120,
                        initValue: duration ?? 15,
                        suffix: Text(' min'),
                      )
                    ]),
                    hideHeader: true,
                    title: Text('Select Duration'),
                    onConfirm: (Picker picker, List<int> value) {
                      setState(() {
                        duration = picker.getSelectedValues()[0];
                      });
                    },
                  ).showDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: duration != null
                      ? Text('$duration min')
                      : Text('Select duration'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (startTime != null && endTime != null && duration != null) {
                  String name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    Activity activity = Activity(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      startTime: startTime!,
                      endTime: endTime!,
                      duration: duration!,
                    );
                    await _addActivity(activity);
                    print(nameController);
                    print(startTime);
                    print(endTime);
                    print(duration);
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditActivityDialog(
      BuildContext context, Activity activity) async {
    TextEditingController nameController =
        TextEditingController(text: activity.name);
    TimeOfDay? startTime = activity.startTime;
    TimeOfDay? endTime = activity.endTime;
    int? duration = activity.duration;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Activity Name'),
              ),
              SizedBox(height: 16),
              Text('Start Time'),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: startTime!,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      startTime = selectedTime;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: startTime != null
                      ? Text('${startTime!.format(context)}')
                      : Text('Select start time'),
                ),
              ),
              SizedBox(height: 16),
              Text('End Time'),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: endTime!,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      endTime = selectedTime;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: endTime != null
                      ? Text('${endTime!.format(context)}')
                      : Text('Select end time'),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Picker(
                    adapter: NumberPickerAdapter(data: [
                      NumberPickerColumn(
                        begin: 5,
                        end: 120,
                        initValue: duration ?? 15,
                        suffix: Text(' min'),
                      )
                    ]),
                    hideHeader: true,
                    title: Text('Select Duration'),
                    onConfirm: (Picker picker, List<int> value) {
                      setState(() {
                        duration = picker.getSelectedValues()[0];
                      });
                    },
                  ).showDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: duration != null
                      ? Text('$duration min')
                      : Text('Select duration'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (startTime != null && endTime != null && duration != null) {
                  String name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    Activity updatedActivity = Activity(
                      id: activity.id,
                      name: name,
                      startTime: startTime!,
                      endTime: endTime!,
                      duration: duration!,
                    );
                    await _updateActivity(updatedActivity);
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Welcome, $businessName!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddActivityDialog(context),
            child: Text('Add Activity'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (BuildContext context, int index) {
                Activity activity = activities[index];
                return ListTile(
                  title: Text(activity.name),
                  subtitle: Text(
                      '${activity.startTime.format(context)} - ${activity.endTime.format(context)} (${activity.duration} min)'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditActivityDialog(context, activity),
                  ),
                  onTap: () => _deleteActivity(activity),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Activity {
  final String id;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int duration;

  Activity({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      name: map['name'],
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
