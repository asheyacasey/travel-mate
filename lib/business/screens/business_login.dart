import 'package:flutter/material.dart';

class BusinessLogin extends StatelessWidget {
  const BusinessLogin({Key? key}) : super(key: key);

  @override
  Widget build(
      context) {
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
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color(0xFFB0DB2D),
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
              //  controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
              //  controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  primary: Color(0xFFB0DB2D),
                  minimumSize: Size(double.infinity, 55.0), // Set button height
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onPressed: () => null
                    // _login(context),
              ),
              SizedBox(height: 20.0),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xFFF5C518),
                  minimumSize: Size(double.infinity, 55.0), // Set button height
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => RegisterScreen()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}