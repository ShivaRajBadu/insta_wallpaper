import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insta_wallpaper/utils/local_storage.dart';

class Instagram {
  static String authorizationCode = '';
  static String accessToken = '';
  static String longlivedAccessToken = '';
  static const String clientID = '1041282353609288';
  static const String appSecret = '324c2ef1c3022d1e1b9e3aec97c130fc';
  static const String redirectUri = 'https://kinu.com.np/';
  static const String scope = 'user_profile,user_media';
  static const String responseType = 'code';
  static const String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=$scope&response_type=$responseType';

  static void getAuthorizationCode(String url) {
    authorizationCode =
        url.replaceAll('$redirectUri?code=', '').replaceAll('#_', '');
  }

  static Future<bool> getTokenAndUserID() async {
    final http.Response response = await http.post(
        Uri.parse("https://api.instagram.com/oauth/access_token/"),
        body: {
          "client_id": clientID,
          "redirect_uri": redirectUri,
          "client_secret": appSecret,
          "code": authorizationCode,
          "grant_type": "authorization_code"
        });
    if (response.statusCode == 200) {
      accessToken = json.decode(response.body)['access_token'];
      await getLongLiveToken();
    }

    return (accessToken.isNotEmpty) ? true : false;
  }

  static Future<bool> getUserDetails() async {
    final apiUrl =
        'https://graph.instagram.com/me?fields=id,username,followers_count,account_type,follows_count,media_count&access_token=$longlivedAccessToken';
    final response = await http.get(Uri.parse(apiUrl));
    final jsonData = json.decode(response.body);
    print(jsonData);
    return true;
  }

  static Future<void> getLongLiveToken() async {
    final response = await http.get(Uri.parse(
        'https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$appSecret&access_token=$accessToken'));
    if (response.statusCode == HttpStatus.ok) {
      final jsonData = json.decode(response.body);
      longlivedAccessToken = jsonData['access_token'];
      // set to local storage;
      SecureStorage.set(SecureStorageKeys.accessToken, longlivedAccessToken);
    }
  }

  static Future<List<Map<String, dynamic>>> getUserMedia(String? token) async {
    var apiUrl = '';
    if (token != null) {
      apiUrl =
          'https://graph.instagram.com/v13.0/me/media?fields=id,media_type,media_url,thumbnail_url,permalink&access_token=$token';
    } else {
      apiUrl =
          'https://graph.instagram.com/v13.0/me/media?fields=id,media_type,media_url,thumbnail_url,permalink&access_token=$longlivedAccessToken';
    }

    final response = await http.get(Uri.parse(apiUrl));

    final jsonData = json.decode(response.body);
    print(jsonData);
    final List<Map<String, dynamic>> mediaList =
        List<Map<String, dynamic>>.from(jsonData['data']);

    return mediaList;
  }
}
