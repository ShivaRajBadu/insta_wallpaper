import 'package:flutter/material.dart';

class ScreenDetails {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double proportionateOfWidth(BuildContext context, double multiple) {
    return MediaQuery.of(context).size.width * multiple;
  }

  static double proportionateOfHeight(BuildContext context, double multiple) {
    return MediaQuery.of(context).size.height * multiple;
  }

  static double topPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  static Brightness systemBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }
}
