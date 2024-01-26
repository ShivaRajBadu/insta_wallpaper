import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/screens/wallpaper_page.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/widgets/custom_page_route.dart';
import 'package:receive_intent/receive_intent.dart';

import 'extras.dart';

void defaultFunction() {}

class IntentUtils {
  static Future<bool> processIntentAndTakeAction(
    Intent? intent, {
    Function() beforeNavigation = defaultFunction,
    Function() afterReturned = defaultFunction,
  }) async {
    if (intent == null || intent.data == null) return false;

    if (navigator == null) return false;

    String data = intent.data!;
    final splittedData = data.split("/");
    final secondLastText = splittedData[splittedData.length - 2];
    final lastText = splittedData[splittedData.length - 1];
    try {
      if (secondLastText == "code") {
        print('get code');
        EasyLoading.show();
        beforeNavigation();
        Instagram.getAuthorizationCode(lastText);
        await Instagram.getTokenAndUserID();
        // navigate to WallpaperApp
        EasyLoading.dismiss();
        navigator?.push(
          CustomPageRoute(
            child: const WallpaperApp(),
          ),
        );
        afterReturned();
      }
    } catch (err) {
      // print(err);
    }
    return false;
  }
}
