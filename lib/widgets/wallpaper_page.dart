import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:insta_wallpaper/utils/instagram.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key, required this.imageUrls});
  final List<Map<String, dynamic>> imageUrls;
  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  int currentImageIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> setWallpaper(String url, BuildContext context) async {
    var file = await DefaultCacheManager().getSingleFile(url);

    await AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
      goToHome: true,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Best'),
      ),
      body: GridView.builder(
        itemCount: widget.imageUrls.length,
        shrinkWrap: true,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Instagram.getUserDetails();
              // setWallpaper(widget.imageUrls[index]['media_url'], context);
            },
            child: Image.network(widget.imageUrls[index]['media_url'],
                fit: BoxFit.fill),
          );
        },
      ),
    );
  }
}
