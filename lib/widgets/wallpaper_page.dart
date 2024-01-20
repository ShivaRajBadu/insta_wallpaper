import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/utils/local_storage.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  Future<List<Map<String, dynamic>>> _getMedia() async {
    final String? accessToken =
        await SecureStorage.get(SecureStorageKeys.accessToken);
    if (accessToken!.isEmpty) {
      return await Instagram.getUserMedia(null);
    } else {
      return await Instagram.getUserMedia(accessToken);
    }
  }

  Future<void> setWallpaper(String url, BuildContext context) async {
    EasyLoading.show();
    var file = await DefaultCacheManager().getSingleFile(url);

    await AsyncWallpaper.setWallpaperFromFile(
      filePath: file.path,
      wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
      goToHome: true,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Best'),
      ),
      body: FutureBuilder(
          future: _getMedia(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              EasyLoading.show();
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.data == null) {
              return Text('No Data');
            } else {
              EasyLoading.dismiss();
              return GridView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Instagram.getUserDetails();
                      setWallpaper(snapshot.data![index]['media_url'], context);
                    },
                    child: Image.network(snapshot.data![index]['media_url'],
                        fit: BoxFit.fill),
                  );
                },
              );
            }
          }),
    );
  }
}
