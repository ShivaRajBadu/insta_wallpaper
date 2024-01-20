import 'package:flutter/material.dart';

import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/widgets/wallpaper_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramAuth extends StatefulWidget {
  const InstagramAuth({super.key});

  @override
  State<InstagramAuth> createState() => _InstagramAuthState();
}

class _InstagramAuthState extends State<InstagramAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..setUserAgent(
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (NavigationRequest request) {
                    if (request.url.startsWith(Instagram.redirectUri)) {
                      Instagram.getAuthorizationCode(request.url);
                      Instagram.getTokenAndUserID().then(
                        (isDone) {
                          if (isDone) {
                            print(Instagram.authorizationCode);
                            print(Instagram.accessToken);
                            Instagram.getUserMedia(null).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WallpaperApp(imageUrls: value),
                                  ));
                            });
                          }
                        },
                      );
                      //close webview

                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(Instagram.url))),
      ),
    );
  }
}
