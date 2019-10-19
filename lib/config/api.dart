import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static String baseUrl = DotEnv().env['ENDPOINT'];

  //auth
  static String register = baseUrl + "hospital/add";
  static String login = baseUrl + "auth/login";

  //get IM code
  static getCode(barcode) {
    return baseUrl + "info/list?search=$barcode";
  }

  //add child
  static String registerChild = baseUrl + "info/add";

  //confirm immunization
  static confirmImmunization(id) => baseUrl + "immunization/add/$id";

  //report disease
  static reportDisease(id) => baseUrl + "disease/new/$id";
}
