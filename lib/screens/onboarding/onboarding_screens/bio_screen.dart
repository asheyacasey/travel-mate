// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:travel_mate/models/checkbox_state.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../widgets/checkbox.dart';
import '../widgets/widgets.dart';

class Biography extends StatefulWidget {
  final TabController tabController;

  const Biography({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<Biography> createState() => _BiographyState();
}

class _BiographyState extends State<Biography> {
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(
                            UniconsLine.smile_beam,
                            size: 40,
                            color: Colors.white,
                          )),
                      SizedBox(height: 10),
                      Text(
                        'Describe Yourself a Bit',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'Add a short description about your travel experience',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w900, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hint: 'Edit bio',
                        onChanged: (value) {
                          context.read<OnboardingBloc>().add(
                                UpdateUser(
                                  user: state.user.copyWith(bio: value),
                                ),
                              );
                        },
                      ),
                      SizedBox(height: 100),
                      Text(
                        'I\'m interested in...',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2!
                            .copyWith(color: Colors.black),
                      ),
                      Column(
                        CheckBox(title: '',),
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
                      CustomButton(
                          tabController: widget.tabController, text: 'NEXT STEP')
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('Something went wrong');
        }
      },
    );
  }
}
