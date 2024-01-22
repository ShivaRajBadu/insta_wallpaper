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
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.2210.144',
    )
    ..loadRequest(
      Uri.parse(Instagram.url),
    );
}
