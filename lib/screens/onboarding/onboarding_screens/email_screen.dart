// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:travel_mate/screens/onboarding/widgets/custom_text_field.dart';
import 'package:travel_mate/screens/onboarding/widgets/custom_text_header.dart';

import '../widgets/custom_button.dart';

class Email extends StatelessWidget {
  final TabController tabController;
  const Email({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CustomTextHeader(
                  tabController: tabController,
                  text: 'What\'s Your Email Address?'),
              CustomTextField(
                  tabController: tabController, text: 'ENTER YOUR EMAIL'),
            ],
          ),
          CustomButton(tabController: tabController, text: 'NEXT STEP')
        ],
      ),
    );
  }
}
