import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class WallpaperPreviewScreen extends StatelessWidget {
  final String mediaUrl;

  final int screenNumber;
  const WallpaperPreviewScreen(
      {super.key, required this.mediaUrl, required this.screenNumber});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              mediaUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // setWallpaper(mediaUrl, screenNumber);
              },
              child: const Text('Set Wallpaper'),
            ),
          ],
        ),
      ),
    );
  }
}
