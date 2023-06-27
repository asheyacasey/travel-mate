import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_mate/business/screens/business_home.dart';
import 'package:travel_mate/business/screens/business_register.dart';
import 'package:google_fonts/google_fonts.dart';


class BusinessLogin extends StatefulWidget {
  const BusinessLogin({Key? key}) : super(key: key);

  @override
  _BusinessLoginState createState() => _BusinessLoginState();
}

class _BusinessLoginState extends State<BusinessLogin> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BusinessHomeScreen()),
        );
      }
    } catch (e) {
      // Authentication failed, display an error message
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100.0),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.fredokaOne(
                    textStyle: TextStyle(
                      fontSize: 40,
                      color: Color(0xFFB0DB2D),
                    ),
                  ),
                  children: [
                    TextSpan(text: 'Travelmate\n'),
                    TextSpan(
                      text: 'for Business',
                      style: TextStyle(
                        color: Color(0xFFF5C518),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Login to access the TravelMate for Business Portal',
                style: GoogleFonts.manrope(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 30.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFFF5C518),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color:Color(0xFFF8E1A1),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFFF5C518),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFFF8E1A1),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height:50.0),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFFB0DB2D),
                  minimumSize: Size(double.infinity, 55.0), // Set button height
                ),
                onPressed: () => _login(context),
                child: Text(
                  'Login',
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color(0xFFF5C518),
                  minimumSize: Size(double.infinity, 55.0), // Set button height
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: GoogleFonts.manrope(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailRegistrationScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
