// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../widgets/widgets.dart';

class Demographics extends StatelessWidget {
  final TabController tabController;

  const Demographics({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is OnboardingLoaded) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: SingleChildScrollView(
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
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w900, color: Colors.grey),
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
                                width: 2.0)),
                        //color: Colors.red,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                decoration: BoxDecoration(),
                                child: CustomCheckbox(
                                  text: 'MALE',
                                  value: state.user.gender == 'Male',
                                  onChanged: (bool? newValue) {
                                    context.read<OnboardingBloc>().add(
                                          UpdateUser(
                                            user: state.user
                                                .copyWith(gender: 'Male'),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: CustomCheckbox(
                                  text: 'FEMALE',
                                  value: state.user.gender == 'Female',
                                  onChanged: (bool? newValue) {
                                    context.read<OnboardingBloc>().add(
                                          UpdateUser(
                                            user: state.user
                                                .copyWith(gender: 'Female'),
                                          ),
                                        );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextHeader(
                        text: 'What\'s your name?',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hint: 'Enter your name',
                        onChanged: (value) {
                          context.read<OnboardingBloc>().add(
                                UpdateUser(
                                  user: state.user.copyWith(
                                    name: value,
                                  ),
                                ),
                              );
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextHeader(
                        text: 'What\'s your job?',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hint: 'Enter job title',
                        onChanged: (value) {
                          context.read<OnboardingBloc>().add(
                                UpdateUser(
                                  user: state.user.copyWith(
                                    jobTitle: value,
                                  ),
                                ),
                              );
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextHeader(
                        text: 'Enter your Age',
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hint: 'Enter your Age',
                        onChanged: (value) {
                          context.read<OnboardingBloc>().add(
                                UpdateUser(
                                  user: state.user.copyWith(
                                    age: int.parse(value),
                                  ),
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Column(
                    children: [
                      StepProgressIndicator(
                        totalSteps: 6,
                        currentStep: 3,
                        selectedColor: Theme.of(context).primaryColor,
                        unselectedColor: Theme.of(context).backgroundColor,
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                          tabController: tabController, text: 'NEXT STEP')
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('Something went wrong.');
        }
      },
    );
  }
}
