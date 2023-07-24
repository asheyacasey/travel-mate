import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    'Bonding',
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

      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${addressController.text}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);

          Activity newActivity = Activity(
            id: activity.id,
            name: activity.name,
            category: activity.category,
            startTime: activity.startTime,
            endTime: activity.endTime,
            duration: activity.duration,
            address: activity.address,
            lat: lat,
            long: lon,
          );

          try {
            await FirebaseFirestore.instance
                .runTransaction((transaction) async {
              DocumentSnapshot snapshot = await transaction.get(docRef);
              List<dynamic> activitiesData = snapshot.get('activities') ?? [];

              // Find the index of the activity to update
              int index =
                  activitiesData.indexWhere((a) => a['id'] == activity.id);
              if (index != -1) {
                // Update the activity at the found index
                activitiesData[index] = newActivity.toMap();
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
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'Edit Activity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      labelText: 'Location',
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
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Business Hours',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start Time',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: startTime != null
                            ? Text(
                                '${startTime!.format(context)} ',
                                style: TextStyle(fontSize: 18),
                              )
                            : Text('Select start time',
                                style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Close Time',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: endTime != null
                            ? Text('${endTime!.format(context)}',
                                style: TextStyle(fontSize: 18))
                            : Text('Select end time',
                                style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              TextButton(
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
                        lat: 0.00,
                        long: 0.00,
                      );
                      await _updateActivity(updatedActivity);
                      Navigator.pop(context);
                      widget.onActivityEdited();
                    }
                  }
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFFB0DB2D),
                  minimumSize: Size(double.infinity, 55.0),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFFF55F5F),
                  minimumSize: Size(double.infinity, 55.0),
                ),
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
