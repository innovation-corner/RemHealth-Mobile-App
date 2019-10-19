import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static storeToken(response) async {
    // save user details and token in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //store token
    String token = response['responseObj']['token'];
    String id = response['responseObj']['user']['id'].toString();

    await prefs.setString('token', token);
    await prefs.setString('id', id);
  }

  static getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    return token;
  }

  static getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id') ?? "";

    return id;
  }

  static logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', null);
  }
}
