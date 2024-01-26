import 'package:flutter/material.dart';

class GlobalState {
  GlobalState._();

  factory GlobalState() {
    return instance;
  }
  static GlobalState instance = GlobalState._();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
