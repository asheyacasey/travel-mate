import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;
  final String text;
  final String? password;
  final String? confirmPassword;

  const CustomButton({
    Key? key,
    required this.tabController,
    this.text = 'Get Started',
    this.password = '',
    this.confirmPassword = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.transparent,
        ),
        onPressed: () async {
          if (tabController.index == 5) {
            Navigator.pushNamed(context, '/');
          } else {
            tabController.animateTo(tabController.index + 1);
          }

          if (tabController.index == 2) {
            print(password);
            print(confirmPassword);
            if (password != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Passwords do not match'),
                ),
              );
              tabController.animateTo(tabController.index - 1);
            }
            if (password == confirmPassword) {
              context.read<SignupCubit>().signupWithCredentials(context);
            }
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
