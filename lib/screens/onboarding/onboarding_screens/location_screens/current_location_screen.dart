import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  bool _isPageScrollable = false;
  late GoogleMapController googleMapController;
  // Add a variable to hold the user's location
  LatLng? userLocation;


  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB0DB2D),
        title: Text(
          'Current Traveler Location',
          style: GoogleFonts.manrope(
            textStyle: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        physics: _isPageScrollable
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0), // Default target position
                  zoom: 0, // Default zoom level
                ), // Set initial position to null
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                  _getUserLocation(); // Fetch user's location and update camera position
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: SizedBox(
          child: FloatingActionButton.extended(
            onPressed: () {
              _getUserLocation(); // Update camera position when button is pressed
            },
            backgroundColor: Color(0xFF80B500), // Set the background color
            label: Text(
              "Save my location",
              style: GoogleFonts.manrope(
                textStyle: TextStyle(
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            icon: Icon(Icons.location_history),
          ),
        ),
      ),
    );
  }

  void _getUserLocation() async {
    Position position = await _determinePosition();
    // Update the userLocation variable with the current position
    userLocation = LatLng(position.latitude, position.longitude);

    googleMapController.moveCamera (
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );

    markers.clear();

    markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        position: LatLng(position.latitude, position.longitude),
      )
    );

    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
