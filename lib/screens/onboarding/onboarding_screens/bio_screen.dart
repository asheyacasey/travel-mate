// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/widgets.dart';

class Biography extends StatelessWidget {
  final TabController tabController;

  const Biography({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextHeader(text: 'Describe Yourself a Bit'),
              CustomTextField(
                hint: 'ENTER YOUR BIO',
                controller: controller,
              ),
              SizedBox(height: 100),
              CustomTextHeader(text: 'What Do You Like?'),
              Row(
                children: [
                  CustomTextContainer(text: 'MOVIES'),
                  CustomTextContainer(text: 'HIKING'),
                  CustomTextContainer(text: 'MUSIC'),
                  CustomTextContainer(text: 'BIKING'),
                ],
              ),
              Row(
                children: [
                  CustomTextContainer(text: 'KARAOKE'),
                  CustomTextContainer(text: 'FREE DIVING'),
                  CustomTextContainer(text: 'FOOD TRIP'),
                ],
              ),
              Row(
                children: [
                  CustomTextContainer(text: 'MUSEUMS'),
                ],
              ),
            ],
          ),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 5,
                selectedColor: Theme.of(context).primaryColor,
                unselectedColor: Theme.of(context).backgroundColor,
              ),
              SizedBox(height: 10),
              CustomButton(tabController: tabController, text: 'NEXT STEP')
            ],
          ),
        ],
      ),
    );
  }
}
