import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/widgets/auth.dart';
import 'package:insta_wallpaper/widgets/insta_auth.dart';
import 'package:insta_wallpaper/widgets/wallpaper_page.dart';
import 'package:provider/provider.dart';

final userState = UserState();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: userState,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          print(settings.name);
          return null;
        },
        debugShowCheckedModeBanner: false,
        home: const InstaWallpaper(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class InstaWallpaper extends StatefulWidget {
  const InstaWallpaper({super.key});

  @override
  State<InstaWallpaper> createState() => _InstaWallpaperState();
}

class _InstaWallpaperState extends State<InstaWallpaper> {
  @override
  void initState() {
    super.initState();
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
        body: Consumer<UserState>(
          builder: (context, state, child) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (state.accessToken != null &&
                      state.accessToken!.isNotEmpty) {
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
                child: state.accessToken == null || state.accessToken!.isEmpty
                    ? const Text('Login with Instagram')
                    : const Text('Check your photos'),
              ),
            );
          },
        ),
      ),
    );
  }
}
