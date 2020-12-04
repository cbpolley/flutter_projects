import 'dart:ui';

import 'package:flutter/material.dart';
import './categories_screen.dart';
import 'custom_swatch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
        accentColor: generateMaterialColor(Palette.accent),
        canvasColor: generateMaterialColor(Palette.canvas),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: generateMaterialColor(Palette.dark),
              ),
              bodyText2: TextStyle(
                color: generateMaterialColor(Palette.dark),
              ),
              headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
      ),
      home: CategoriesScreen(),
    );
  }
}

class Palette {
  static const Color primary = Color(0xFF2A9D8F);
  static const Color accent = Color(0xFFE9C46A);
  static const Color canvas = Color(0xFF264653);
  static const Color dark = Color(0xFF30292F);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeliMeals'),
      ),
      body: Center(
        child: Text('Navigation Time!'),
        color: primary.shade900,
      ),
    );
  }
}
