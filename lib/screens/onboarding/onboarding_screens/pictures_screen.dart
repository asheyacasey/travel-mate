// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/widgets.dart';

class Pictures extends StatelessWidget {
  final TabController tabController;

  const Pictures({
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
                  tabController: tabController, text: 'Add 2 or More Pictures'),
              SizedBox(height: 10),
              Row(
                children: [
                  CustomImageContainer(
                    tabController: tabController,
                  ),
                  CustomImageContainer(
                    tabController: tabController,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomImageContainer(
                    tabController: tabController,
                  ),
                  CustomImageContainer(
                    tabController: tabController,
                  ),
                ],
              )
            ],
          ),
          CustomButton(tabController: tabController, text: 'NEXT STEP')
        ],
      ),
    );
  }
}
