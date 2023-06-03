import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42736133580664, -122.085749655962), zoom: 14.0);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current User Location'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14.0),
            ),
          );

          markers.clear();

          markers.add(
            Marker(
                markerId: MarkerId("currentLocation"),
                position: LatLng(position.latitude, position.longitude)),
          );

          setState(() {});
        },
        label: Text("Current Location"),
        icon: Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnable) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
