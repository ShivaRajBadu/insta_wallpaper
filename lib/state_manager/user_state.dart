import 'package:flutter/material.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/utils/local_storage.dart';

class UserState extends ChangeNotifier {
  UserState() {
    getAccessToken();
  }
  List<Map<String, dynamic>> _mediaList = [];
  List<Map<String, dynamic>> get mediaList => _mediaList;
  String? _accessToken;
  String? get accessToken => _accessToken;
  void setAccessToken(String? accessToken) {
    _accessToken = accessToken;
    SecureStorage.set(SecureStorageKeys.accessToken, accessToken!);
    notifyListeners();
  }

  Future<void> getAccessToken() async {
    _accessToken = await SecureStorage.get(SecureStorageKeys.accessToken);
    notifyListeners();
  }

  Future<void> getMedia() async {
    _mediaList = await Instagram.getUserMedia(accessToken);

    notifyListeners();
  }
}
