import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/ui/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  setPathUrlStrategy();
  return runZonedGuarded(
    () async {
      runApp(
        FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(home: _Splash());
            }
            return const MyApp();
          },
        ),
      );
    },
    (e, s) {
      //
    },
  );
}

Future<void> setPreferredOrientations() async {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class _Splash extends StatelessWidget {
  const _Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(child: Text('Your Music', style: Theme.of(context).textTheme.headline4!.copyWith(color: greyColor))),
    );
  }
}
