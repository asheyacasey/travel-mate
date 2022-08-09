// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';

import '../widgets/custom_button.dart';
import '../widgets/widgets.dart';

class Email extends StatelessWidget {
  final TabController tabController;
  const Email({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome,',
                      style: Theme.of(context)
                      .primaryTextTheme
                      .headline2!
                      .copyWith(height: 1.8, color:Theme.of(context).primaryColor, fontSize: 36)),
                  Text('TravelMate!',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline2!
                          .copyWith(color: Theme.of(context).primaryColorLight, fontSize: 36)
                  ),
                  SizedBox(height: 50,),
                  CustomTextHeader(
                    text: 'What\'s Your Email Address?',
                  ),
                  CustomTextField(
                    hint: 'ENTER YOUR EMAIL',
                    onChanged: (value) {
                      context.read<SignupCubit>().emailChanged(value);
                      print(state.email);
                    },
                  ),
                  SizedBox(height: 10,),
                  CustomTextHeader(text: 'Create A Password'),
                  CustomTextField(
                    hint: 'ENTER YOUR PASSWORD',
                    onChanged: (value) {
                      context.read<SignupCubit>().passwordChanged(value);
                      print(state.password);
                    },
                  ),
                ],
              ),
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
        );
      },
    );
  }
}
