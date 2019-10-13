import 'package:flutter/material.dart';

class CommonColor {
  static Color textWhite = Colors.white;
  static Color error = Colors.red;
  static Color textBlack = Color(0xFF343434);
  static Color textGrey = Color(0xFF696969);
  static Color textRed = Color(0xFFFB0402);
  static Color textOrange = Color(0xFFEB5757);
  static Color textBlue = Color(0xFF0A4DD0);

  static Color backgroundColor = Color(0xFFF7F7F7);

  static LinearGradient commonButtonColor = LinearGradient(
      colors: <Color>[Color(0xFFFF7777), Color(0xFFF44040)],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
      stops: const <double>[0.0, 1],
      tileMode: TileMode.clamp);

  static LinearGradient commonLinearGradient = LinearGradient(
      colors: <Color>[Color(0xFFFF7777), Color(0xFFF44040)],
      begin: FractionalOffset.topLeft,
      end: FractionalOffset.bottomRight,
      stops: const <double>[0.0, 1],
      tileMode: TileMode.clamp);

  static LinearGradient leftRightLinearGradient = LinearGradient(
      colors: <Color>[Color(0xFFFF7777), Color(0xFFF44040)],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
      stops: const <double>[0.0, 1],
      tileMode: TileMode.clamp);

}
