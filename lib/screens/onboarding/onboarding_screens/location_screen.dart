import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/custom_button.dart';
import 'location_screens/current_location_screen.dart';

class LocationScreen extends StatelessWidget {
  final TabController tabController;

  const LocationScreen({
    Key? key,
    required this.tabController,
  }) : super(key: key);

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
                      return const CurrentLocation();
                    },
                  ),
                );
              },
              child: Text("Current Location"),
            ),
            SizedBox(
              height: 10,
            ),
            SliderDemo(),
            SizedBox(height: 10),
            Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 6,
                  currentStep: 1,
                  selectedColor: Theme.of(context).primaryColor,
                  unselectedColor: Theme.of(context).backgroundColor,
                ),
                SizedBox(height: 10),
                CustomButton(
                  tabController: tabController,
                  text: 'NEXT STEP',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  late double _currentSliderValue = 0.0;
  late Position _currentPosition;

  void initState() {
    super.initState();
    _initLocation();
  }

  void _initLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentSliderValue = _currentPosition.latitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Selected radius: ${_currentSliderValue.toStringAsFixed(6)} km'),
          Slider(
            value: _currentSliderValue,
            min: -90,
            max: 90,
            divisions: 180,
            label: _currentSliderValue.toStringAsFixed(6),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
                _currentPosition = Position(
                    longitude: _currentSliderValue,
                    latitude: _currentPosition.longitude,
                    timestamp: _currentPosition.timestamp,
                    accuracy: _currentPosition.accuracy,
                    altitude: _currentPosition.altitude,
                    heading: _currentPosition.heading,
                    speed: _currentPosition.speed,
                    speedAccuracy: _currentPosition.speedAccuracy);
              });
            },
          ),
        ],
      ),
    );
  }
}
