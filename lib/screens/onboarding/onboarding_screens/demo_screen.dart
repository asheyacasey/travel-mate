// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../widgets/widgets.dart';

class Demographics extends StatelessWidget {
  final TabController tabController;

  const Demographics({
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
              Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Icon(
                    UniconsLine.user_check,
                    size: 40,
                    color: Colors.white,
                  )),
              SizedBox(height: 20),
              Text(
                'About you',
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline2!
                    .copyWith(color: Colors.black),
              ),
              Text(
                'We\'d like to know more about you',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w900, color: Colors.grey),
              ),
              SizedBox(height: 20),

              CustomTextHeader(
                text: 'Choose your Gender',
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 2.0
                  )
                ),
                //color: Colors.red,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(),
                        child: CustomCheckbox(
                          text: 'MALE',
                          tabController: tabController,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: CustomCheckbox(

                          text: 'FEMALE',
                          tabController: tabController,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // CustomCheckbox(tabController: tabController, text: 'MALE'),
              // CustomCheckbox(tabController: tabController, text: 'FEMALE'),
              SizedBox(height: 50),
              CustomTextHeader(
                text: 'Enter your birthday',
              ),
              SizedBox(height: 15),
              CustomTextField(
                hint: 'Enter your age',
                controller: controller,
              ),
            ],
          ),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 3,
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


