import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static storeToken(response) async {
    // save user details and token in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //store token
    String token = response['responseObj']['token'];

    await prefs.setString('token', token);
  }

  static getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    return token;
  }

  static logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', null);
  }
}
