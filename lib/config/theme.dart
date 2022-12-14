import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


ThemeData theme() {
  return ThemeData(
      primaryColor: const Color(0xFFB0DB2D),
    primaryColorLight: const Color(0xFFF5C518),
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Color(0xFFF4F4F4),

    primaryTextTheme: TextTheme(
      headline2: TextStyle(
        fontFamily: GoogleFonts.fredokaOne().fontFamily,
        color: Color(0xFFB0DB2D),
        fontSize: 24,
      ),
    ),

    iconTheme: IconThemeData(
      color: Colors.black,

    ),

    fontFamily: GoogleFonts.manrope().fontFamily,
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      headline2: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headline3: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      headline4: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      headline5: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      headline6: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodyText1: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      bodyText2: TextStyle(
        color: Color(0xFF2B2E4A),
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),


    ),


  );
}