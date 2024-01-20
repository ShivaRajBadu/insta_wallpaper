import 'package:flutter/material.dart';
import 'package:insta_wallpaper/utils/instagram.dart';
import 'package:insta_wallpaper/utils/local_storage.dart';
import 'package:insta_wallpaper/widgets/auth.dart';
import 'package:insta_wallpaper/widgets/wallpaper_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late String? accessToken = '';

  @override
  void initState() {
    _getAccessToken();
    super.initState();
  }

  Future<void> _getAccessToken() async {
    accessToken = await SecureStorage.get(SecureStorageKeys.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper App'),
        centerTitle: true,
        elevation: 8,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              // if (accessToken != null) {
              //   Instagram.getUserMedia(accessToken).then((value) {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => WallpaperApp(imageUrls: value),
              //         ));
              //   });
              // } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InstagramAuth(),
                ),
              );
              // }
            },
            child: const Text('Login with Instagram')),
      ),
    );
  }
}
