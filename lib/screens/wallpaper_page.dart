import 'dart:async';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/main.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/widgets/wallpaper/Image_with_shimmer.dart';
import 'package:insta_wallpaper/widgets/wallpaper/grid_shimmer.dart';
import 'package:provider/provider.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    userState.getMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Best'),
      ),
      body: Consumer<UserState>(
        builder: (context, state, child) {
          if (state.mediaList.isEmpty) {
            return const CustomImageShimmer();
          } else {
            return GridView.builder(
              itemCount: state.mediaList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      // border: isSelected
                      //     ? Border.all(
                      //         color: const Color(0xffd62976),
                      //         width: 4.0,
                      //       )
                      //     : null,
                      ),
                  child: Stack(
                    children: [
                      ShimmerImage(
                        imageUrl: state.mediaList[index]['media_url'],
                      ),
                      Positioned.fill(
                          child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          overlayColor: MaterialStatePropertyAll<Color>(
                              Colors.white.withOpacity(0.5)),
                          hoverDuration: const Duration(microseconds: 1),
                          onTap: () {
                            showBottomSheet(
                                context, state.mediaList[index]['media_url']);
                          },
                        ),
                      ))
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context, String mediaUrl) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      // showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Set as Wallpaper',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WallpaperScreenWidget(
                      icon: Icons.home,
                      text: 'Home screen',
                      mediaUrl: mediaUrl),
                  WallpaperScreenWidget(
                    icon: Icons.lock,
                    text: 'Lock screen',
                    mediaUrl: mediaUrl,
                  ),
                  WallpaperScreenWidget(
                    icon: Icons.image,
                    text: 'Home and lock screens',
                    mediaUrl: mediaUrl,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: const Color(0xffd62976).withOpacity(0.8),
      content: const Text(
        'Please select at least one image',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 120,
        left: 60,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class WallpaperScreenWidget extends StatelessWidget {
  const WallpaperScreenWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.mediaUrl,
  });

  final IconData icon;
  final String text;
  final String mediaUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (text == 'Home screen') {
          setWallpaper(mediaUrl, AsyncWallpaper.HOME_SCREEN);
        } else if (text == 'Lock screen') {
          setWallpaper(mediaUrl, AsyncWallpaper.LOCK_SCREEN);
        } else if (text == 'Home and lock screens') {
          setWallpaper(mediaUrl, AsyncWallpaper.BOTH_SCREENS);
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.teal.shade600,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}

Future<void> setWallpaper(String url, int screen) async {
  EasyLoading.show();
  var file = await DefaultCacheManager().getSingleFile(url);

  await AsyncWallpaper.setWallpaperFromFile(
    filePath: file.path,
    wallpaperLocation: screen,
    goToHome: false,
    toastDetails: ToastDetails.success(),
    errorToastDetails: ToastDetails.error(),
  );
  EasyLoading.dismiss();
}
