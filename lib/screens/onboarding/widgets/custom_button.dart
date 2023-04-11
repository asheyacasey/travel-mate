import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/cubits/signup/signup_cubit.dart';

class CustomButton extends StatelessWidget {
  final TabController tabController;
  final String text;
  final String? password;
  final String? confirmPassword;
  final String? email;

  const CustomButton({
    Key? key,
    required this.tabController,
    this.text = 'Get Started',
    this.password = '',
    this.confirmPassword = '',
    this.email = '',
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
          backgroundColor: Colors.transparent,
          //primary: Colors.transparent,
        ),
        onPressed: () async {
          if (tabController.index == 5) {
            Navigator.pushNamed(context, '/');
          } else {
            tabController.animateTo(tabController.index + 1);
            //!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email)
          }

          if (tabController.index == 2) {
            print(password);
            print(confirmPassword);
            if (email! != '' &&
                !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(email!)) {
              if (password != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid credentials format'),
                  ),
                );
                tabController.animateTo(tabController.index - 1);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a valid email'),
                  ),
                );
                tabController.animateTo(tabController.index - 1);
              }
            } else if (password != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Passwords do not match'),
                ),
              );
              tabController.animateTo(tabController.index - 1);
            } else if (password == confirmPassword) {
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
