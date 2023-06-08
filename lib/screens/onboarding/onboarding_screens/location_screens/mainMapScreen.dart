import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/location_screens/current_location_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screens/location_screens/simple_google_map.dart';
import 'package:travel_mate/screens/onboarding/widgets/widgets.dart';
import 'package:unicons/unicons.dart';

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
      body: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB0DB2D),
                ),
                child: Icon(
                  UniconsLine.location_point,
                  size: 36,
                  color: Colors.white,
                )
            ),
            SizedBox(height: 10),
            Text(
              'Location',
              style: GoogleFonts.fredokaOne(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'To help you find potential matches near your location, we require access to your device\'s location information.',
              style: GoogleFonts.manrope(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),

            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const CurrentLocation();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Color(0xFFB0DB2D),
                    elevation: 0, // Adjust the elevation value to move the shadow
                  ),
                  child: Text(
                    "Get My Current Location",
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
