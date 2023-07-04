import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_mate/business/screens/business_home.dart';

class EditActivityScreen extends StatefulWidget {
  final VoidCallback onActivityEdited;
  final Activity activity;

  const EditActivityScreen({
    Key? key,
    required this.onActivityEdited,
    required this.activity,
  }) : super(key: key);

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedCategory;
  List<String> _suggestions = [];
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

  Future<void> _updateActivity(Activity activity) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('business').doc(user.uid);

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(docRef);
          List<dynamic> activitiesData = snapshot.get('activities') ?? [];

          // Find the index of the activity to update
          int index = activitiesData.indexWhere((a) => a['id'] == activity.id);
          if (index != -1) {
            // Update the activity at the found index
            activitiesData[index] = activity.toMap();
            transaction.update(docRef, {'activities': activitiesData});
            print('Activity updated successfully!');
          } else {
            print('Activity not found in the array!');
          }
        });
      } catch (e) {
        print('Error updating activity: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.activity.name);
    addressController = TextEditingController(text: widget.activity.address);
    startTime = widget.activity.startTime;
    endTime = widget.activity.endTime;
    selectedCategory = widget.activity.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Activity'),
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
              Stack(
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
                          // Calculate duration based on selected category
                          int duration = _calculateDuration(selectedCategory!);

                          Activity updatedActivity = Activity(
                            id: widget.activity.id,
                            name: name,
                            category: selectedCategory!,
                            startTime: startTime!,
                            endTime: endTime!,
                            duration: duration,
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
