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
import '../providers/user_details.dart';
import '../providers/member.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  Timer _authTimer;

  final _auth = FirebaseAuth.instance;

  static const String apiKey = "AIzaSyBkBDzEbsvwTikbpGUdind9XnXJSrTRkEg";

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_tokenExpiryDate != null &&
        _tokenExpiryDate.isAfter(DateTime.now()) &&
        _tokenExpiryDate != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_tokenExpiryDate != null &&
        _tokenExpiryDate.isAfter(DateTime.now()) &&
        _tokenExpiryDate != null) {
      return _userId;
    }
    return null;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(
          {
            'userName': username,
            'email': email,
          },
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials.';

      if (err.message != null) {
        message = err.message;
      }

      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: Theme.of(context).accentColor,
      //   ),
      // );
    } catch (err) {
      print(err);
    }
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  //   final url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(response.body);
  //     if (responseData['error'] != null) {
  //       throw HttpException(responseData['error']['message']);
  //     }
  //     _token = responseData['idToken'];
  //     _userId = responseData['localId'];
  //     _tokenExpiryDate = DateTime.now().add(
  //       Duration(
  //         seconds: int.parse(
  //           responseData['expiresIn'],
  //         ),
  //       ),
  //     );
  //     _autoLogout();
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode(
  //       {
  //         'token': _token,
  //         'userId': _userId,
  //         'tokenExpiryDate': _tokenExpiryDate.toIso8601String(),
  //       },
  //     );
  //     prefs.setString('userData', userData);
  //     if (urlSegment == 'signUp') {
  //       UserDetails(_token, _userId, Member(id: userId, memberName: userId))
  //           .updateUserDetails(
  //         Member(id: userId, memberName: userId),
  //       );
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, email, false);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, email, true);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map;
    final expiryDate = DateTime.parse(extractedUserData['tokenExpiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _tokenExpiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _tokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeUntilExpiry =
        _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeUntilExpiry), logout);
  }
}
