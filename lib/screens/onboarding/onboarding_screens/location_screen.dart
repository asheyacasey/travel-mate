// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../widgets/widgets.dart';

class LocationTab extends StatefulWidget {
  final TabController tabController;

  const LocationTab({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  late GoogleMapController _mapController;
  location.Location _location = location.Location();
  LatLng _currentPosition = LatLng(0, 0);
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((location.LocationData currentLocation) {
      setState(() {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _latitude = currentLocation.latitude.toString();
        _longitude = currentLocation.longitude.toString();
      });
      print('Latitude: $_latitude, Longitude: $_longitude');
    });
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    final hasPermission = await _location.requestPermission();
    if (hasPermission == location.PermissionStatus.granted) {
      final currentLocation = await _location.getLocation();
      setState(() {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _latitude = currentLocation.latitude.toString();
        _longitude = currentLocation.longitude.toString();
      });
      print('Latitude: $_latitude, Longitude: $_longitude');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    final LatLng center = position.target;
    print('Current Location: ${center.latitude}, ${center.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is OnboardingLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(
                            UniconsLine.location_point,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Where are you?',
                          style: Theme.of(context).primaryTextTheme.headline2!.copyWith(color: Colors.black, fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 1.0, // Set the aspect ratio to make it square
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 15),
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  markers: {
                    Marker(markerId: MarkerId('currentLocation'), position: _currentPosition),
                  },
                  myLocationEnabled: true,
                ),
              ),
              SizedBox(height: 220),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 6,
                      currentStep: 6,
                      selectedColor: Theme.of(context).primaryColor,
                      unselectedColor: Theme.of(context).backgroundColor,
                    ),
                    SizedBox(height: 10),
                    CustomButton(tabController: widget.tabController, text: 'DONE'),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text('Something went wrong');
        }
      },
    );
  }
}
