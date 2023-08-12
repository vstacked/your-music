import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/hive_config.dart';
import 'constants/colors.dart';
import 'constants/key.dart';
import 'ui/my_app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(KeyConstant.prefNotification, jsonEncode(message.data));
}

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      if (!kIsWeb) {
        await _setPortraitOrientations();
        await HiveConfig().initialize();
        await JustAudioBackground.init(
          androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
          androidNotificationChannelName: 'Audio playback',
          androidNotificationOngoing: true,
        );
      }

      setPathUrlStrategy();
      runApp(!kIsWeb ? const _MobileApp() : const MyApp());
    },
    (e, s) {},
  );
}

Future<void> _setPortraitOrientations() => SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

class _MobileApp extends StatefulWidget {
  const _MobileApp({Key? key}) : super(key: key);

  @override
  __MobileAppState createState() => __MobileAppState();
}

class __MobileAppState extends State<_MobileApp> {
  final future = Future.delayed(const Duration(seconds: 3));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Splashscreen
          return MaterialApp(
            home: Scaffold(
              backgroundColor: secondaryColor,
              body: Center(
                child: Text(
                  'Your Music',
                  style: Theme.of(context).textTheme.headline4!.copyWith(color: greyColor),
                ),
              ),
            ),
          );
        }

        return const MyApp();
      },
    );
  }
}
