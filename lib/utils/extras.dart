import 'package:flutter/material.dart';
import 'package:insta_wallpaper/state_manager/global_state.dart';

NavigatorState? get navigator => GlobalState().navigatorKey.currentState;
