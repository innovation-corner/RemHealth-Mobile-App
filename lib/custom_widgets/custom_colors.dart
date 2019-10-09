import 'package:flutter/material.dart';

class RemColors {
  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor white = MaterialColor(0xffFFFFFF, color);
  static MaterialColor black = MaterialColor(0xff0B0A22, color);
  static MaterialColor green = MaterialColor(0xff46C10D, color);
  static MaterialColor blue = MaterialColor(0xff0167F6, color);
  static MaterialColor red = MaterialColor(0xffD63811, color);
  static MaterialColor grey2 = MaterialColor(0xff9594B2, color);
  static Color shadow = Color.fromRGBO(0, 0, 0, 0.22);
}
