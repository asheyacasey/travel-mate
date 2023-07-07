import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/business/screens/business_home.dart';

class AddNewActivityScreen extends StatefulWidget {
  final VoidCallback onActivityAdded;

  const AddNewActivityScreen({
    super.key,
    required this.onActivityAdded,
  });
  @override
  _AddNewActivityScreenState createState() => _AddNewActivityScreenState();
}

class _AddNewActivityScreenState extends State<AddNewActivityScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedCategory;
  List<String> categories = [
    'Swimming',
    'Foods',
    'Adventure',
    'Beach',
    'Night Life',
    'Land Tour',
    'Hiking',
    'Pool',
    'Diving'
  ];

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
    }
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
              Text('Category'),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
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
                          selectedCategory != null) {
                        String name = nameController.text.trim();
                        String address = addressController.text.trim();
                        if (name.isNotEmpty && address.isNotEmpty) {
                          int duration = _calculateDuration(selectedCategory!);
                          Activity activity = Activity(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: name,
                            category: selectedCategory!,
                            startTime: startTime!,
                            endTime: endTime!,
                            duration: duration,
                            address: address,
                          );
                          await _addActivity(activity);
                          Navigator.pop(context);
                          widget.onActivityAdded();
                        }
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateDuration(String category) {
    switch (category) {
      case 'Swimming':
        return 120;
      case 'Foods':
        return 60;
      case 'Adventure':
        return 60;
      case 'Beach':
        return 120;
      case 'Night Life':
        return 180;
      case 'Land Tour':
        return 360;
      case 'Hiking':
        return 180;
      case 'Pool':
        return 120;
      case 'Diving':
        return 120;
      default:
        return 0;
    }
  }
}
