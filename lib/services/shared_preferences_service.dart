import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  setToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('token', token);
  }

  setUser(dynamic userInfo) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('user', json.encode(userInfo));
  }

  // Future clearToken() async {
  //   await _prefs.clear();
  // }

  getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }

  getUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return json.decode(_prefs.getString('user'));
  }
}

SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
