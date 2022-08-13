import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/widgets/custom_appbar.dart';
import 'package:travel_mate/widgets/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          return LoginScreen();
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
              beginColor: Theme.of(context).accentColor,
              endColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              text: 'SIGNUP',
              beginColor: Theme.of(context).accentColor,
              endColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {},
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
    return TextField(
      onChanged: (email) {},
      decoration: const InputDecoration(labelText: 'Email'),
    );
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (email) {},
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
    );
  }
}
