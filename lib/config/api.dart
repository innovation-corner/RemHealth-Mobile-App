import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static String baseUrl = DotEnv().env['ENDPOINT'];

  //auth
  static String register = baseUrl + "hospital/add";
  static String login = baseUrl + "auth/login";
}
