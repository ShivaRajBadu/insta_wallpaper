import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insta_wallpaper/screens/wallpaper_images.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/utils/constants.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/widgets/custom_page_route.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: AppBar(
          title: const Text('Insta Wallpaper'),
          centerTitle: true,
          elevation: 10,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Consumer<UserState>(
                builder: (context, state, child) {
                  print('called consumer build main apge');
                  if (state.accessToken == null || state.accessToken!.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.white),
                            elevation:
                                const MaterialStatePropertyAll<double>(5),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                              color: Colors.teal,
                            ),
                          )),
                    );
                  } else {
                    return FutureBuilder(
                        future: getUserData(state.accessToken!),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Animate(
                                      autoPlay: true,
                                      effects: const [
                                        FadeEffect(),
                                        ScaleEffect()
                                      ],
                                      child: const Text(
                                        'Hi !',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                        ),
                                      ),
                                    ),
                                    // Transform.rotate(
                                    //   angle: -math.pi / 8,
                                    //   child: const Text(
                                    //     '\u270B ',
                                    //     style: TextStyle(
                                    //       fontSize: 40,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Ready to change your wallpaper',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CustomPageRoute(
                                          child: const WallpaperImages(),
                                        ));
                                  },
                                  child: Text('Check my photos'),
                                ),
                                if (state.accessToken != null &&
                                    state.accessToken!.isNotEmpty)
                                  ElevatedButton(
                                      onPressed: () {
                                        Provider.of<UserState>(context,
                                                listen: false)
                                            .logout();
                                      },
                                      child: const Text('Logout'))
                              ],
                            );
                          }
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
