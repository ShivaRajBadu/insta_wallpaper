import 'dart:async';

import 'package:flutter/material.dart' hide Intent;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:insta_wallpaper/screens/home_page.dart';
import 'package:insta_wallpaper/state_manager/global_state.dart';
import 'package:insta_wallpaper/state_manager/user_state.dart';
import 'package:insta_wallpaper/utils/intent_utils.dart';
import 'package:provider/provider.dart';
import 'package:receive_intent/receive_intent.dart';

final userState = UserState();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    _initializeReceiveIntent();
    super.initState();
  }

  Future<void> _initializeReceiveIntent() async {
    _streamSubscription = ReceiveIntent.receivedIntentStream.listen(
      (Intent? intent) {
        IntentUtils.processIntentAndTakeAction(intent);
      },
      onError: (err) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: userState,
      child: MaterialApp(
        navigatorKey: GlobalState().navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
