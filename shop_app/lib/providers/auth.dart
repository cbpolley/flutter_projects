import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpiryDate;
  String _userId;
  Timer _authTimer;

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
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB-rirZeNS1aoM9OS_gG4FVFD2O52HpXOw';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _tokenExpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'tokenExpiryDate': _tokenExpiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
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
