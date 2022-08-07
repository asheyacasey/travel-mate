import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_mate/screens/onboarding/widgets/custom_button.dart';

class Start extends StatelessWidget {
  final TabController tabController;
  const Start({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 200,
                width: 200,
                child: SvgPicture.asset(
                  'assets/logo.svg',
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Welcome to TravelMate',
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: 20),
              Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(height: 1.8)),
            ],
          ),
          CustomButton(tabController: tabController)
        ],
      )),
    );
  }
}
