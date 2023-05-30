import 'package:flutter/material.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/location_screens/simple_google_map.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});
  static const String routeName = '/mainJournal';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MainMapScreen(),
    );
  }

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Location"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SimpleMapLocation();
                    },
                  ),
                );
              },
              child: Text("Simple Map Location"),
            ),
          ],
        ),
      ),
    );
  }
}
