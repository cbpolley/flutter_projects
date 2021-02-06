import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String _userId = "";
  String get userId => _userId;
  set userId(newValue) => _userId = newValue;
}
