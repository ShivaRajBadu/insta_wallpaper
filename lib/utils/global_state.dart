import 'package:flutter/material.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GlobalState {
  GlobalState._();

  factory GlobalState() {
    return instance;
  }
  static GlobalState instance = GlobalState._();

  final WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.white)
    ..setUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
    ..loadRequest(
      Uri.parse(Instagram.url),
    );
}
