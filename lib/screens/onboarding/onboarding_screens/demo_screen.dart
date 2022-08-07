// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/widgets.dart';

class Demographics extends StatelessWidget {
  final TabController tabController;

  const Demographics({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextHeader(
                  tabController: tabController, text: 'What\'s Your Gender?'),
              SizedBox(height: 10),
              CustomCheckbox(tabController: tabController, text: 'MALE'),
              CustomCheckbox(tabController: tabController, text: 'FEMALE'),
              SizedBox(height: 100),
              CustomTextHeader(
                  tabController: tabController, text: 'What\'s Your Age?'),
              CustomTextField(
                  tabController: tabController, text: 'ENTER YOUR AGE'),
            ],
          ),
          CustomButton(tabController: tabController, text: 'NEXT STEP')
        ],
      ),
    );
  }
}
