import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:insta_wallpaper/screens/wallpaper_images.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/utils/circular_blur_painter.dart';
import 'package:insta_wallpaper/utils/constants.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/utils/screen_details.dart';
import 'package:insta_wallpaper/widgets/custom_page_route.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const colorizeColors = [
  Color(0xffe74454),
  Color.fromARGB(255, 181, 90, 197),
  Color.fromARGB(255, 88, 152, 204),
  Color.fromARGB(255, 182, 172, 87),
  Color.fromARGB(255, 230, 120, 112),
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
    return const Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: Stack(
              children: [
                BackgroundGradient(),
                Center(
                  child: UserInfoSection(),
                ),
                // Center(
                //   child: MobileFrame(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
      decoration: const BoxDecoration(color: Color(0xff181822), boxShadow: [
        BoxShadow(
          color: Colors.green,
          blurRadius: 10,
          offset: Offset(0, -5),
          spreadRadius: 10,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Logo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Insta Wallpaper',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Selector<UserState, String?>(
            selector: (context, state) => state.accessToken,
            builder: (context, accessToken, child) {
              if (accessToken == null || accessToken.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return IconButton(
                  onPressed: () {
                    Provider.of<UserState>(context, listen: false).logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleBlurPainter(circleWidth: 20, blurSigma: 3),
      child: Container(
        width: ScreenDetails.width(context),
        height: ScreenDetails.height(context),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xff14151f),
              Color(0xff414352),
              Color(0xff242431),
              Color(0xff414352),
              // Color(0xfff6004d),
              Color(0xff14151f),
            ],
            center: Alignment.center,
            radius: 1.5,
            focal: Alignment(0.5, 0.5),
            focalRadius: 0.5,
          ),
        ),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      width: ScreenDetails.proportionateOfWidth(context, 0.8),
      height: ScreenDetails.proportionateOfHeight(context, 0.77),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_img.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Selector<UserState, String?>(
        selector: (p0, p1) => p1.accessToken,
        builder: (context, accessToken, child) {
          if (accessToken == null || accessToken.isEmpty) {
            return const UserInfoUnauthenticated();
          } else {
            return UserInfoAuthenticated(accessToken: accessToken);
          }
        },
      ),
    );
  }
}

class UserInfoUnauthenticated extends StatelessWidget {
  const UserInfoUnauthenticated({super.key});

  @override
  Widget build(BuildContext context) {
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
                  text: 'Change your wallpaper directly \n from ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
                TextSpan(
                  text: 'Instagram.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffd62976),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Login with Instagram to get started.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll<Color>(
              Colors.transparent,
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(
                  color: Colors.white,
                ),
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
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class UserInfoAuthenticated extends StatelessWidget {
  final String accessToken;

  const UserInfoAuthenticated({super.key, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Instagram.getUserDetails(accessToken),
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: ScreenDetails.proportionateOfWidth(context, 0.4),
                child: AnimatedTextKit(
                  pause: const Duration(microseconds: 400),
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      snapshot.data?['username'],
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color(0xffd62976),
                      ),
                      speed: const Duration(seconds: 1),
                      colors: colorizeColors,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Ready to change your wallpaper',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                    Colors.transparent,
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      child: const WallpaperImages(),
                    ),
                  );
                },
                child: const Text(
                  'Check my photos',
                  style: TextStyle(
                    color: Color(0xfffff8ff),
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
}

class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenDetails.proportionateOfWidth(context, 0.9),
      height: ScreenDetails.proportionateOfHeight(context, 0.8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/mobile_frame.png',
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
