import 'package:flutter/material.dart';

class ItineraryScreen extends StatelessWidget {
  final Map<String, dynamic>? itinerary;

  const ItineraryScreen({Key? key, required this.itinerary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> activities = itinerary?['activities'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final String activityName = activity['activityName'];
          final String category = activity['category'];
          final String address = activity['address'];
          final int duration = activity['duration'];
          final String timeStart = activity['timeStart'];
          final String timeEnd = activity['timeEnd'];

          return ListTile(
            title: Text(activityName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: $category'),
                Text('Address: $address'),
                Text('Duration: $duration mins'),
                Text('Time Start: $timeStart'),
                Text('Time End: $timeEnd'),
              ],
            ),
          );
        },
      ),
    );
  }
}
