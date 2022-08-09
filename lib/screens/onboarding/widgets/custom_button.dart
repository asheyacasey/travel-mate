import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;
  final String text;

  const CustomButton({
    Key? key,
    required this.tabController,
    this.text = 'START',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.transparent,
        ),
        onPressed: () {
          tabController.animateTo(tabController.index + 1);
          if (tabController.index == 2) {
            context.read<SignupCubit>().signupWithCredentials();
          }
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
