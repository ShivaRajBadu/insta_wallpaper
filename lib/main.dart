import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyWidget(),
      builder: EasyLoading.init(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? accessToken = '';
  @override
  initState() {
    super.initState();
    _getAccessToken().then((value) => setState(() {
          accessToken = value;
          print('called here');
          print(value);
        }));
  }

  Future<String?> _getAccessToken() async {
    final token = await SecureStorage.get(SecureStorageKeys.accessToken);
    return token;
  }

  @override
  Widget build(BuildContext context) {
    print('called build');
    print(accessToken);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper App'),
        centerTitle: true,
        elevation: 8,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (accessToken != null && accessToken!.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WallpaperApp(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InstagramAuth(),
                ),
              );
            }
          },
          child: accessToken == null || accessToken!.isEmpty
              ? const Text('Login with Instagram')
              : const Text('Check your photos'),
        ),
      ),
    );
  }
}
