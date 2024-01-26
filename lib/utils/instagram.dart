import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:insta_wallpaper/main.dart';
import 'package:insta_wallpaper/utils/constants.dart';

class Instagram {
  static String authorizationCode = '';
  static String accessToken = '';
  static String longlivedAccessToken = '';

  static void getAuthorizationCode(String code) {
    if (code.endsWith("#_")) {
      authorizationCode = code.substring(0, code.length - 2);
    } else {
      authorizationCode = code;
    }
    print('cleanded code');
  }

  static Future<void> getTokenAndUserID() async {
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
      // set to local storage
      print('tokeen received');
      userState.setAccessToken(accessToken);
      getLongLiveToken();
    }
  }

  static Future<void> getLongLiveToken() async {
    final response = await http.get(Uri.parse(
        'https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$appSecret&access_token=$accessToken'));
    if (response.statusCode == HttpStatus.ok) {
      final jsonData = json.decode(response.body);
      longlivedAccessToken = jsonData['access_token'];
      // set to local storage;
      print('long token');
      userState.setAccessToken(longlivedAccessToken);
    }
  }

  static Future<Map<String, dynamic>> getUserDetails(String token) async {
    final apiUrl =
        'https://graph.instagram.com/me?fields=id,username,followers_count,account_type,follows_count,media_count&access_token=$token';
    final response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }

  static Future<List<Map<String, dynamic>>> getUserMedia(String? token) async {
    final apiUrl =
        'https://graph.instagram.com/v13.0/me/media?fields=id,media_type,media_url,thumbnail_url&access_token=$token';

    final response = await http.get(Uri.parse(apiUrl));

    final jsonData = json.decode(response.body);
    // filter data by media_type = "IMAGE"
    final List<Map<String, dynamic>> mediaList = filterMediaList(jsonData);

    // final List<Map<String, dynamic>> mediaList =
    //     List<Map<String, dynamic>>.from(jsonData['data']);

    return mediaList;
  }

  static List<Map<String, dynamic>> filterMediaList(jsonData) {
    List<Map<String, dynamic>> mediaList = [];

    for (var item in jsonData['data']) {
      if (item['media_type'] == 'IMAGE') {
        mediaList.add(item);
      }
    }
    return mediaList;
  }
}
