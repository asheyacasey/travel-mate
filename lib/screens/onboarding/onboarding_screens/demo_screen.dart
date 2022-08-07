// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_header.dart';

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
            children: [
              CustomTextHeader(
                  tabController: tabController, text: 'What\'s Your Gender?'),
              CustomTextHeader(
                  tabController: tabController, text: 'What\'s Your Age?'),
            ],
          ),
          CustomButton(tabController: tabController, text: 'NEXT STEP')
        ],
      ),
    );
  }
}
