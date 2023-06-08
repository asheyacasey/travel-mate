import 'package:flutter/material.dart';
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
            StepProgressIndicator(
              totalSteps: 6,
              currentStep: 6,
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Theme.of(context).colorScheme.background,
            ),
            SizedBox(height: 10),
            CustomButton(tabController: tabController, text: 'NEXT STEP')
          ],
        ),
      ),
    );
  }
}
