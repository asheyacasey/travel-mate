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
      appBar: CustomAppBar(
        title: 'TravelMate',
        hasAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailInput(),
            const SizedBox(height: 10),
            PasswordInput(),
            const SizedBox(height: 10),
            CustomElevatedButton(
              text: 'LOGIN',
              beginColor: Colors.white,
              endColor: Colors.white,
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                context.read<LoginCubit>().logInWithCredentials();
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              text: 'SIGNUP',
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
          ],
        ),
      ),
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
          decoration: const InputDecoration(labelText: 'Email'),
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
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        );
      },
    );
  }
}
