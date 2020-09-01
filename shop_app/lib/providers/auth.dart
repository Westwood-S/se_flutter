import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _id;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //we have to set getter for others to access user id
  String get userId {
    return _id;
  }

  Future<void> signup(String email, String pwd) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBLslrcauBzjAkIjXUEGTlPiAZxbJBlyXo';
    await http
        .post(url,
            body: json.encode({
              'email': email,
              'password': pwd,
              'returnSecureToken': true,
            }))
        .then((res) {
      final message = json.decode(res.body);
      if (message['error'] != null) {
        throw HttpException(message['error']['message']);
      }
    });
  }

  Future<void> signin(String email, String pwd) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBLslrcauBzjAkIjXUEGTlPiAZxbJBlyXo';
    await http
        .post(url,
            body: json.encode({
              'email': email,
              'password': pwd,
              'returnSecureToken': true,
            }))
        .then((res) async {
      final message = json.decode(res.body);

      if (message['error'] != null) {
        throw HttpException(message['error']['message']);
      }
      _id = message['localId'];
      _token = message['idToken'];
      _expiryTime = DateTime.now().add(Duration(
        seconds: int.parse(message['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
      final preference = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _id,
        'expiryDate': _expiryTime.toIso8601String(),
      });
      preference.setString('userData', userData);
    });
  }

  Future<bool> autoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extractUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractUserData['token'];
    _id = extractUserData['userId'];
    _expiryTime = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _expiryTime = null;
    _id = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final preferencess = await SharedPreferences.getInstance();
    preferencess.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
