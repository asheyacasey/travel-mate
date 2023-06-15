// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';
import '../widgets/widgets.dart';

class Email extends StatelessWidget {
  final TabController tabController;
  const Email({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email;
    String? pass;
    String? confirmPass;
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                            .copyWith(
                                height: 1.8,
                                color: Theme.of(context).primaryColor,
                                fontSize: 36)),
                    Text('TravelMate!',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2!
                            .copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 36)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Create an account and start looking for the perfect travel date to your exciting journey.',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1!
                            .copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 50,
                    ),
                    CustomTextHeader(
                      text: 'Email Address',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      hint: 'Enter your email',
                      onChanged: (value) {
                        context.read<SignupCubit>().emailChanged(value);
                        email = value;
                        print(email);
                        print(state.email);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextHeader(text: 'Create a Password'),
                    SizedBox(height: 5),
                    CustomTextField(
                      hint: 'Enter your password',
                      isPassword: true,
                      onChanged: (value) {
                        context.read<SignupCubit>().passwordChanged(value);
                        pass = value;
                        print('The pass is ${pass}');
                        print(state.password);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextHeader(text: 'Confirm your Password'),
                    SizedBox(height: 5),
                    CustomTextField(
                      isPassword: true,
                      hint: 'Enter your password',
                      onChanged: (value) {
                        context.read<SignupCubit>().passwordChanged(value);
                        confirmPass = value;
                        print('The confirm pass is ${confirmPass}');
                        print(state.password);
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 5,
                      currentStep: 1,
                      selectedColor: Theme.of(context).primaryColor,
                      unselectedColor: Theme.of(context).backgroundColor,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      email: email,
                      password: pass,
                      confirmPassword: confirmPass,
                      tabController: tabController,
                      text: 'NEXT STEP',
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
