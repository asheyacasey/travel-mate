// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:unicons/unicons.dart';

import '../../../blocs/blocs.dart';
import '../../../models/category_model.dart';
import '../widgets/widgets.dart';

class Interest extends StatelessWidget {
  final TabController tabController;

  const Interest({
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
                    Row(
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Icon(
                              UniconsLine.heart,
                              size: 30,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'My Interest',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2!
                              .copyWith(color: Colors.black, fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomCategoryFilter(categories: Category.categories,),
                  ],
                ),
                Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 7,
                      currentStep: 6,
                      selectedColor: Theme.of(context).primaryColor,
                      unselectedColor: Theme.of(context).backgroundColor,
                    ),
                    SizedBox(height: 10),
                    CustomButton(tabController: tabController, text: 'DONE')
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

class CustomCategoryFilter extends StatelessWidget {
  final List<Category> categories;
  const CustomCategoryFilter({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categories[index].name,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 25,
                child: Checkbox(
                  value: false,
                  onChanged: (bool? newValue) {},
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
