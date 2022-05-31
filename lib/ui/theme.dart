import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors_util.dart';

const primarycolor = '#2080ca';
const secondarycolor = "#536f82";

class Themes {
  static final light = ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: HexColor(primarycolor)),
      brightness: Brightness.light);

  static final dark = ThemeData(
      appBarTheme: AppBarTheme(backgroundColor: HexColor(secondarycolor)),
      brightness: Brightness.dark);
}

TextStyle get basicTextStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  ));
}

TextStyle get headerStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get taskHeader {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get taskTitle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get taskTitleWhite {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get taskBasicStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  ));
}

TextStyle get taskSubtitle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: HexColor('#1E90FF'),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get homePageTaskTitle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: HexColor('#F5FEFD'),
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ));
}

TextStyle get homePageTaskNormal {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: HexColor('#F5FEFD'),
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ));
}

TextStyle get loginPageTitle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get loginPageSubtitle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  ));
}