import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_mate/blocs/auth/auth_bloc.dart';
import 'package:travel_mate/cubits/cubits.dart';
import 'package:travel_mate/screens/home/home_screen.dart';
import 'package:travel_mate/screens/onboarding/onboarding_screen.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';
import 'package:travel_mate/widgets/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          return BlocProvider.of<AuthBloc>(context).state.status ==
                  AuthStatus.authenticated
              ? HomeScreen()
              : LoginScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: CustomAppBar(
      //   title: 'TravelMate',
      //   hasAction: false,
      // ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
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
                        'Start looking for the perfect travel date to your exciting journey!',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText1!
                            .copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 50,
                    ),
                    EmailInput(),
                    const SizedBox(height: 10),
                    PasswordInput(),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 30,
                    ),
                    CustomElevatedButton2(
                      text: 'Log In',
                      beginColor: Colors.white,
                      endColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<LoginCubit>().logInWithCredentials();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton2(
                      text: 'Sign Up',
                      beginColor: Theme.of(context).primaryColor,
                      endColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                        OnboardingScreen.routeName,
                        ModalRoute.withName(
                          '/onboarding',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Email',
            contentPadding:
                const EdgeInsets.only(bottom: 5.0, top: 12.5, left: 15.0),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColorLight),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5C518), width: 2),
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Password',
            contentPadding:
                const EdgeInsets.only(bottom: 5.0, top: 12.5, left: 15.0),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColorLight),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5C518), width: 2),
                borderRadius: BorderRadius.circular(8)),
          ),
          obscureText: true,
        );
      },
    );
  }
}
