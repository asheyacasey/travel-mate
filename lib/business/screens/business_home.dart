import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
        leading: SvgPicture.asset(
          'assets/logo.svg',
          height: 90,
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'Activity List',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ',
                    style:
                        Theme.of(context).primaryTextTheme.headline2!.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 23,
                            ),
                  ),
                  Text(
                    '$businessName!',
                    style:
                        Theme.of(context).primaryTextTheme.headline2!.copyWith(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 23,
                            ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, bottom: 10.0, right: 16.0),
              child: Text(
                'Feel the thrill of adventure! Add an exhilarating activity that will leave travelers in awe and make their itinerary plan unforgettable.',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    //fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFF8F7F7),
                        ),
                        child: ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${activity.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text('Category: ${activity.category}',
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    'Business Hours: ${activity.startTime.format(context)} -  ${activity.endTime.format(context)}',
                                    style: TextStyle(fontSize: 16)),
                                Text('Location: ${activity.address}',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditActivityScreen(
                                  onActivityEdited: _fetchActivities,
                                  activity: activity,
                                ),
                              ),
                            ),
                          ),
                          onLongPress: () => showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Delete Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    SizedBox(height: 8),
                                    Text(
                                        'Are you sure you want to delete this activity?',
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancel',
                                                style:
                                                    TextStyle(fontSize: 16))),
                                        SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () async {
                                            await _deleteActivity(activity);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
        backgroundColor: Color(0xFFB0DB2D),
        child: Icon(Icons.add),
      ),
    );
  }
}

class Activity {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double long;
  final String category;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int duration;

  Activity({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
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
      lat: map['lat'],
      long: map['long'],
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
      'lat': lat,
      'long': long,
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
