import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static String baseUrl = DotEnv().env['ENDPOINT'];

  //auth
  static String register = baseUrl + "auth/hospital";
  static String login = baseUrl + "auth/login";

  //get IM code
  static getCode(barcode) {
    return baseUrl + "info/list?search=$barcode";
  }

  //add child
  static String registerChild = baseUrl + "info/add";

  //edit child details
  static editChild(code) => baseUrl + "info/edit/$code";

  //confirm immunization
  static confirmImmunization(id) => baseUrl + "immunization/add/$id";

  //report disease
  static reportDisease(id) => baseUrl + "disease/new/$id";

  //get child details with IM code
  static getDetailsByIm(code) => baseUrl + "info/child/$code";

  //list child Immunizations
  static listImmunization(id) => baseUrl + "immunization/child/$id";

  //list vaccines 
  static String getVaccines = baseUrl + "vaccine/get";
}
