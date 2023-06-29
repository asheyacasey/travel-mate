import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_mate/business/screens/business_info.dart';

import '../../screens/onboarding/widgets/custom_text_header.dart';

class EmailRegistrationScreen extends StatefulWidget {
  @override
  _EmailRegistrationScreenState createState() =>
      _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isRegistering = false;

  String? _emailError;
  String? _passwordError;

  void _register() async {
    setState(() {
      _isRegistering = true;
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validateEmail(email) || !_validatePassword(password)) {
      setState(() {
        _isRegistering = false;
      });
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('business')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
      });

      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BusinessInfoScreen(userId: userCredential.user!.uid),
          ),
        );
      }

      print('User registered: ${userCredential.user?.email}');
    } catch (e) {
      print('Registration error: $e');
      setState(() {
        _isRegistering = false;
      });
    }
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailError = 'Email is required.';
      });
      return false;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$')
        .hasMatch(value)) {
      setState(() {
        _emailError = 'Invalid email format.';
      });
      return false;
    }
    return true;
  }

  bool _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordError = 'Password is required.';
      });
      return false;
    } else if (value.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters.';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          'Registration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: Theme.of(context).primaryTextTheme.headline2!.copyWith(
                    height: 1.8,
                    color: Theme.of(context).primaryColor,
                    fontSize: 36,
                  ),
            ),
            Text(
              'TravelMate!',
              style: Theme.of(context).primaryTextTheme.headline2!.copyWith(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 36,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              'Create an account and start looking for the perfect travel date to your exciting journey.',
              style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 50),
            CustomTextHeader(text: 'Email Address'),
            SizedBox(height: 5),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                errorText: _emailError,
              ),
            ),
            SizedBox(height: 20),
            CustomTextHeader(text: 'Create a Password'),
            SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                errorText: _passwordError,
              ),
            ),
            SizedBox(height: 50),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Color(0xFFB0DB2D),
                minimumSize: Size(double.infinity, 55.0), // Set button height
              ),
              onPressed: _isRegistering ? null : _register,
              child: _isRegistering
                  ? CircularProgressIndicator()
                  : Text(
                      'REGISTER',
                      style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

// class CustomTextHeader extends StatelessWidget {
//   final String text;

//   const CustomTextHeader({
//     Key? key,
//     required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }
// }
