import 'package:flutter/material.dart';
import 'package:insta_wallpaper/state_manager/global_state.dart';

NavigatorState? get navigator => GlobalState().navigatorKey.currentState;

class WallpaperPreviewArguments {
  WallpaperPreviewArguments({
    required this.mediaUrl,
    required this.screenNumber,
  });
  final String mediaUrl;
  final int screenNumber;
}
