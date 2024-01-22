import 'package:flutter/material.dart';
import 'package:insta_wallpaper/state_manager/global_state.dart';

import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/widgets/progress_bar.dart';
import 'package:insta_wallpaper/screens/wallpaper_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramAuth extends StatefulWidget {
  const InstagramAuth({super.key});

  @override
  State<InstagramAuth> createState() => _InstagramAuthState();
}

class _InstagramAuthState extends State<InstagramAuth> {
  final webViewController = GlobalState().webViewController;
  late final ValueNotifier<int> _progress;

  @override
  void initState() {
    _progress = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: webViewController
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      _progress.value = progress;
                    },
                    onPageStarted: (String url) {
                      _progress.value = 0;
                    },
                    onPageFinished: (String url) {
                      _progress.value = 100;
                    },
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith(Instagram.redirectUri)) {
                        Instagram.getAuthorizationCode(request.url);
                        Instagram.getTokenAndUserID().then(
                          (isDone) {
                            if (isDone) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WallpaperApp(),
                                ),
                              );
                            }
                          },
                        );
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                ),
            ),
            AnimatedBuilder(
              animation: _progress,
              builder: (context, _) {
                if (_progress.value == 0 || _progress.value == 100) {
                  return const SizedBox();
                }
                return ProgressBar(
                  progress: _progress.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
