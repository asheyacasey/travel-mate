import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMapLocation extends StatefulWidget {
  const SimpleMapLocation({super.key});

  @override
  State<SimpleMapLocation> createState() => _SimpleMapLocationState();
}

class _SimpleMapLocationState extends State<SimpleMapLocation> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(
      target: LatLng(37.42736133580664, -122.085749655962), zoom: 14.0);

  static const CameraPosition targetPosition = CameraPosition(
      target: LatLng(37.43896865331129, -122.08832357078792),
      zoom: 14.0,
      bearing: 192.0,
      tilt: 60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Google Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          goToLake();
        },
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> goToLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }
}
