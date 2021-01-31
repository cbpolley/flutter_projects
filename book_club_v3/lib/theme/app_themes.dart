import 'package:flutter/material.dart';
import './generate_material_color.dart';

class AppTheme {
  // Colour palette
  static const green = const Color(0xff28764E);
  static const brown = const Color(0xffA85439);
  static const amber = const Color(0xffA88939);
  static const offWhite = const Color(0xfff9efdc);
  static const purple = const Color(0xff6D256D);
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: generateMaterialColor(green),
    accentColor: Colors.amber,
    highlightColor: purple,
    fontFamily: 'Raleway',
    backgroundColor: Colors.white,
    canvasColor: Colors.white,
    // textTheme: TextTheme(headline6: ),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.white),
      caption: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
      subtitle2: TextStyle(color: Colors.white),
      headline1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headline2: TextStyle(color: Colors.white),
      headline3: TextStyle(color: Colors.white),
      headline4: TextStyle(color: Colors.white),
      headline5: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          fontSize: 16),
      headline6: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1),
      button: TextStyle(color: offWhite),
    ),
    cardColor: Colors.blueGrey[800],

    appBarTheme: AppBarTheme(color: green, elevation: 5),
    dialogBackgroundColor: Colors.blueGrey[800],
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.blueGrey[800],
      actionTextColor: Colors.amber,
    ),
  );

  // static final ThemeData darkTheme = ThemeData(
  //   scaffoldBackgroundColor: Colors.black,
  //   appBarTheme: AppBarTheme(
  //     color: Colors.black,
  //     iconTheme: IconThemeData(
  //       color: offWhite,
  //     ),
  //   ),
  //   colorScheme: ColorScheme.light(
  //     primary: Colors.black,
  //     onPrimary: Colors.black,
  //     primaryVariant: Colors.black,
  //     secondary: Colors.red,
  //   ),
  //   cardTheme: CardTheme(
  //     color: Colors.black,
  //   ),
  //   iconTheme: IconThemeData(
  //     color: offWhite,
  //   ),
  //   textTheme: TextTheme(
  //     title: TextStyle(
  //       color: offWhite,
  //       fontSize: 20.0,
  //     ),
  //     subtitle: TextStyle(
  //       color: offWhite,
  //       fontSize: 18.0,
  //     ),
  //   ),
  // );
}
