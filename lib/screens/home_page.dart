import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:insta_wallpaper/screens/wallpaper_images.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/utils/constants.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/widgets/custom_page_route.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, dynamic>> getUserData(String token) async {
    return await Instagram.getUserDetails(token);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Logo'),
                  const Text(
                    'Insta Wallpaper',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Selector<UserState, String?>(
                    selector: (context, state) => state.accessToken,
                    builder: (context, accessToken, child) {
                      if (accessToken == null || accessToken.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        return IconButton(
                          onPressed: () {
                            Provider.of<UserState>(context, listen: false)
                                .logout();
                          },
                          icon: const Icon(Icons.logout),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
            ),
            Selector<UserState, String?>(
              selector: (p0, p1) => p1.accessToken,
              builder: (context, accessToken, child) {
                if (accessToken == null || accessToken.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Change your wallpaper directly from \n',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                              TextSpan(
                                text: 'Instagram.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffd62976),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Login with instagram to get started.',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                            Colors.white,
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                  color: Color(0xffd62976),
                                )),
                          ),
                        ),
                        onPressed: () async {
                          launchUrl(
                            Uri.parse(authUrl),
                          );
                        },
                        child: const Text(
                          'Login with Instagram',
                          style: TextStyle(
                            color: Color(0xffd62976),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return FutureBuilder(
                    future: getUserData(accessToken),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hi !',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedTextKit(
                              pause: const Duration(microseconds: 400),
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  snapshot.data!['username'],
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Color(0xffd62976),
                                  ),
                                  speed: const Duration(seconds: 1),
                                  colors: colorizeColors,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Ready to change your wallpaper',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  Colors.white,
                                ),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                      color: Color(0xffd62976),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      child: const WallpaperImages(),
                                    ));
                              },
                              child: const Text(
                                'Check my photos',
                                style: TextStyle(
                                  color: Color(0xffd62976),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
