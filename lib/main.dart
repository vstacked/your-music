import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_music/ui/web/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  return runZonedGuarded(
    () async {
      runApp(const MyApp());
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
