import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config/hive_config.dart';
import 'constants/colors.dart';
import 'ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await _setPortraitOrientations();
    await HiveConfig().initialize();
    // TODO use https://pub.dev/packages/audio_service
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  setPathUrlStrategy();
  return runZonedGuarded(
    () => runApp(!kIsWeb ? const _MobileApp() : const MyApp()),
    (e, s) {
      // TODO add crashlytics
    },
  );
}

Future<void> _setPortraitOrientations() =>
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

class _MobileApp extends StatelessWidget {
  const _MobileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Splashscreen
          return MaterialApp(
            home: Scaffold(
              backgroundColor: secondaryColor,
              body: Center(
                child: Text(
                  'Your Music',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: greyColor),
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
