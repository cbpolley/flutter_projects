import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/config.dart';
import 'package:provider/provider.dart';
import '../theme/dark_theme.dart';

class DarkModeSwitch extends StatefulWidget {
  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  var whatMode = currentTheme.currentTheme();

  bool isSwitched = false;

  // bool isSwitched  = whatMode(;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
        padding: const EdgeInsets.all(16.0),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (isSwitched) ? 'Light Mode' : 'Dark Mode',
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
            ),
            Switch(
              value: themeChange.darkTheme,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  themeChange.darkTheme = value;
                });
              },
            )
          ],
        ));
  }
}
