import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../ui/android/home/favorite.dart';
import '../../ui/android/home/home.dart' as android;
import '../../ui/android/now_playing/now_playing.dart';
import '../../ui/web/home/home.dart' as web;
import '../../ui/web/login/login.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';
  static const String favorite = '/favorite';
  static const String nowPlaying = '/now-playing';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => (kIsWeb) ? const web.Home() : const android.Home(),
    login: (BuildContext context) => const Login(),
    favorite: (BuildContext context) => const Favorite(),
    nowPlaying: (BuildContext context) => const NowPlaying(),
  };
}
