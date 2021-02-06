import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/http_exception.dart';
import '../models/user_model.dart';
import '../providers/user_details.dart';
import '../providers/member.dart';

class Auth with ChangeNotifier {
  // String _token;
  // DateTime _tokenExpiryDate;
  // String _userId;
  // Timer _authTimer;
  bool _isAuth;
  bool get isAuth => _isAuth;
  set isAuth(newValue) => _isAuth = (newValue);

  // final _auth = FirebaseAuth.instance;

  // set isAuth =

}
