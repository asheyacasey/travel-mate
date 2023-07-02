import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/business/screens/business_home.dart';

class EditActivityScreen extends StatefulWidget {
  final VoidCallback onActivityEdited;
  final Activity activity;

  const EditActivityScreen({
    super.key,
    required this.onActivityEdited,
    required this.activity,
  });
  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? duration;
  List<Activity> activities = [];
  List<String> _suggestions = [];

  Future<List<String>> _getAddressSuggestions(String query) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final suggestions =
            data.map((item) => item['display_name'] as String).toList();
        return suggestions;
      } else {
        throw Exception(
            'Failed to load address suggestions. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load address suggestions: $e');
    }
  }

  void _updateAddressSuggestions(String query) {
    _getAddressSuggestions(query).then((suggestions) {
      // Show the suggestions to the user (e.g., using a ListView)
      print(suggestions);
      setState(() {
        _suggestions = suggestions;
      });
    }).catchError((error) {
      print('Failed to load address suggestions: $error');
    });
  }

  // Future<void> _addActivity(Activity activity) async {
  //   try {
  //     final userDoc = FirebaseFirestore.instance
  //         .collection('business')
  //         .doc('user_document');
  //     await userDoc.update({
  //       'activities': FieldValue.arrayUnion([activity.toMap()]),
  //     });
  //     print('Activity added successfully');
  //   } catch (e) {
  //     print('Failed to add activity: $e');
  //   }
  // }

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
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    nameController = TextEditingController(text: widget.activity.name);
    addressController = TextEditingController(text: widget.activity.address);
    startTime = widget.activity.startTime;
    endTime = widget.activity.endTime;
    duration = widget.activity.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Activity'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Activity Name'),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: 'Enter your business address',
                    ),
                    onChanged: (query) {
                      _updateAddressSuggestions(query);
                    },
                  ),
                  SizedBox(height: 10),
                  if (_suggestions.isNotEmpty)
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              setState(() {
                                addressController.text = suggestion;
                                _suggestions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Text('Start Time'),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: startTime ?? TimeOfDay.now(),
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (startTime != null &&
                          endTime != null &&
                          duration != null) {
                        String name = nameController.text.trim();
                        String address = addressController.text.trim();
                        if (name.isNotEmpty && address.isNotEmpty) {
                          Activity updatedActivity = Activity(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: name,
                            startTime: startTime!,
                            endTime: endTime!,
                            duration: duration!,
                            address: address,
                          );
                          await _updateActivity(updatedActivity);
                          Navigator.pop(context);
                          widget.onActivityEdited();
                        }
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
