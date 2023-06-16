// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../widgets/widgets.dart';

class CustomRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5, // Adjust the scale value to make the circle bigger
      child: Theme(
        data: Theme.of(context).copyWith(
          toggleableActiveColor: Color(0xFFF5C518),
        ),
        child: Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Color(0xFFF5C518), // Set the active color to Color(0xFFF5C518)
        ),
      ),
    );
  }
}

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        UniconsLine.user_check,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
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
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text(
                                'MALE',
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: CustomRadio<String>(
                                value: 'Male',
                                groupValue: state.user.gender,
                                onChanged: (String? newValue) {
                                  context.read<OnboardingBloc>().add(
                                    UpdateUser(
                                      user: state.user.copyWith(
                                        gender: newValue,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text(
                                'FEMALE',
                                style: TextStyle(fontSize: 16),
                              ),
                              leading: CustomRadio<String>(
                                value: 'Female',
                                groupValue: state.user.gender,
                                onChanged: (String? newValue) {
                                  context.read<OnboardingBloc>().add(
                                    UpdateUser(
                                      user: state.user.copyWith(
                                        gender: newValue,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextHeader(
                      text: 'What\'s your name?',
                    ),
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),
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
                    SizedBox(height: 15),
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
                Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 5,
                      currentStep: 2,
                      selectedColor: Theme.of(context).primaryColor,
                      unselectedColor: Theme.of(context).backgroundColor,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      tabController: tabController,
                      text: 'NEXT STEP',
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Text('Something went wrong.');
        }
      },
    );
  }
}
