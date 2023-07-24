import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../widgets/widgets.dart';

// ignore: must_be_immutable
class Biography extends StatelessWidget {
  final TabController tabController;
  String? interest;
  final List<String> availableTags = [
    'Swimming',
    'Foods',
    'Adventure',
    'Beach',
    'Bonding',
    'Land Tour',
    'Hiking',
    'Pool',
    'Diving'
  ];

  bool isTagSelected(String tag, List<String> selectedTags) {
    return selectedTags.contains(tag);
  }

  Biography({
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
          List<String> selectedTags = List<String>.from(state.user.interests);

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
                        UniconsLine.smile_beam,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
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
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                          ),
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
                    SizedBox(height: 50),
                    Text(
                      'I\'m interested in...',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline2!
                          .copyWith(color: Colors.black),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: availableTags.map((tag) {
                        final isSelected = isTagSelected(tag, selectedTags);
                        return FilterChip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              fontSize:
                                  16, // Specify the desired font size here
                            ),
                          ),
                          selected: isSelected,
                          selectedColor:
                              isSelected ? Color(0xFFF5C518) : Colors.black,
                          onSelected: (isSelected) {
                            if (isSelected) {
                              if (!selectedTags.contains(tag)) {
                                selectedTags.add(tag);
                              }
                            } else {
                              selectedTags.remove(tag);
                            }
                            context.read<OnboardingBloc>().add(
                                  UpdateUserInterest(
                                    user: state.user,
                                    interest: tag,
                                    selectedTags: selectedTags,
                                  ),
                                );
                          },
                        );
                      }).toList(),
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
                        tabController: tabController, text: 'NEXT STEP'),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Text('Something went wrong');
        }
      },
    );
  }
}
