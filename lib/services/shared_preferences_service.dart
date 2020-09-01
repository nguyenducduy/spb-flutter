import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  setToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('token', token);
  }

  // Future clearToken() async {
  //   await _prefs.clear();
  // }

  getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }
}

SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
