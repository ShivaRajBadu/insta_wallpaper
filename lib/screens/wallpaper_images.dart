import 'dart:async';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:insta_wallpaper/main.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/utils/screen_details.dart';
import 'package:insta_wallpaper/widgets/wallpaper/Image_with_shimmer.dart';
import 'package:insta_wallpaper/widgets/wallpaper/grid_shimmer.dart';
import 'package:provider/provider.dart';

class WallpaperImages extends StatefulWidget {
  const WallpaperImages({super.key});

  @override
  State<WallpaperImages> createState() => _WallpaperImagesState();
}

class _WallpaperImagesState extends State<WallpaperImages> {
  BannerAd? _bannerAd;

  final String _adUnitId = 'ca-app-pub-7603504878357258~6702096957';

  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    userState.getMedia();
    _loadAd();
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            print('called loaded');
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          print('called open');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('called cloaded');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          print('called impression');
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Choose Your Best',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 8,
        backgroundColor: const Color(0xff181822),
      ),
      body: Consumer<UserState>(
        builder: (context, state, child) {
          if (state.mediaList.isEmpty) {
            return const CustomImageShimmer();
          } else {
            return GridView.builder(
              itemCount: state.mediaList.length + (state.mediaList.length ~/ 6),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.0,
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) {
                if (index % 7 == 6) {
                  return AdWidget(ad: _bannerAd!);
                } else {
                  final mediaIndex = index - (index ~/ 7);
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    child: Stack(
                      children: [
                        ShimmerImage(
                          imageUrl: state.mediaList[mediaIndex]['media_url'],
                        ),
                        Positioned.fill(
                            child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            overlayColor: MaterialStatePropertyAll<Color>(
                                Colors.white.withOpacity(0.5)),
                            hoverDuration: const Duration(microseconds: 1),
                            onTap: () {
                              showBottomSheet(context,
                                  state.mediaList[mediaIndex]['media_url']);
                            },
                          ),
                        ))
                      ],
                    ),
                  );
                }
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
          // Navigator.push(
          //   context,
          //   CustomPageRoute(
          //     child: WallpaperPreviewScreen(
          //       mediaUrl: mediaUrl,
          //       screenNumber: AsyncWallpaper.HOME_SCREEN,
          //     ),
          //   ),
          // );

          setWallpaper(mediaUrl, AsyncWallpaper.HOME_SCREEN);
        } else if (text == 'Lock screen') {
          // Navigator.push(
          //   context,
          //   CustomPageRoute(
          //     child: WallpaperPreviewScreen(
          //       mediaUrl: mediaUrl,
          //       screenNumber: AsyncWallpaper.LOCK_SCREEN,
          //     ),
          //   ),
          // );
          setWallpaper(mediaUrl, AsyncWallpaper.LOCK_SCREEN);
        } else if (text == 'Home and lock screens') {
          // Navigator.push(
          //   context,
          //   CustomPageRoute(
          //     child: WallpaperPreviewScreen(
          //       mediaUrl: mediaUrl,
          //       screenNumber: AsyncWallpaper.BOTH_SCREENS,
          //     ),
          //   ),
          // );
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
  EasyLoading.show(status: 'Setting wallpaper...');
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
