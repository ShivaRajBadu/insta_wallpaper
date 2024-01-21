import 'dart:async';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/main.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workmanager/workmanager.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  List<Map<String, dynamic>> selectedMedia = [];
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    userState.getMedia();
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerOneOffTask('badu', 'badu task');
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {
      try {
        print("Native called background task: $task");
        // _executeTask(); // Call the static method directly
        return Future.value(true);
      } catch (err) {
        Logger().e(err.toString());
        throw Exception(err);
      }
    });
  }

  bool _executeTask() {
    try {
      setWallpaper(selectedMedia[currentImageIndex]['media_url']);
      currentImageIndex = (currentImageIndex + 1) % selectedMedia.length;
      print('Background task executed successfully.');
      return true; // Task succeeded
    } catch (e) {
      print('Error in background task: $e');
      return false; // Task failed
    }
  }

  void _startTimer() {
    Workmanager().registerPeriodicTask(
      "changeWallpaper",
      "changeWallpaperTask",
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Best'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<UserState>(
              builder: (context, state, child) {
                if (state.mediaList.isEmpty) {
                  return const CustomImageShimmer();
                } else {
                  return GridView.builder(
                    itemCount: state.mediaList.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.0,
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      final isSelected =
                          selectedMedia.contains(state.mediaList[index]);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            selectedMedia.remove(state.mediaList[index]);
                          } else {
                            selectedMedia.add(state.mediaList[index]);
                          }
                          setState(() {});
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xffd62976),
                                    width: 4.0,
                                  )
                                : null,
                          ),
                          child: ShimmerImage(
                            imageUrl: state.mediaList[index]['media_url'],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          setWallpaperWidget(context),
        ],
      ),
    );
  }

  GestureDetector setWallpaperWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedMedia.isNotEmpty) {
          if (selectedMedia.length > 1) {
            _startTimer();
          } else {
            setWallpaper(selectedMedia[0]['media_url']);
          }
        } else {
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
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xffd62976).withOpacity(0.9),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 94, 40, 40),
              blurRadius: 5,
              offset: Offset(0, 5),
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Text(
          'Set wallpaper',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

Future<void> setWallpaper(String url) async {
  EasyLoading.show();
  var file = await DefaultCacheManager().getSingleFile(url);

  await AsyncWallpaper.setWallpaperFromFile(
    filePath: file.path,
    wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
    goToHome: false,
    toastDetails: ToastDetails.success(),
    errorToastDetails: ToastDetails.error(),
  );
  EasyLoading.dismiss();
}

class CustomImageShimmer extends StatelessWidget {
  const CustomImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xffd62976).withOpacity(0.8),
      highlightColor: const Color(0xffd62976).withOpacity(0.7),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.0,
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: 200.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class ShimmerImage extends StatelessWidget {
  final String imageUrl;

  const ShimmerImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      boxFit: BoxFit.cover,
      shimmerBaseColor: const Color(0xffd62976).withOpacity(0.8),
      shimmerHighlightColor: const Color(0xffd62976).withOpacity(0.7),
      imageUrl: imageUrl,
    );
  }
}
