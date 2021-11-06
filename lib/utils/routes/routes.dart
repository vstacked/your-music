import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:your_music/ui/android/home.dart' as android;
import 'package:your_music/ui/web/home/home.dart' as web;
import 'package:your_music/ui/web/login/login.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => kIsWeb ? const web.Home() : const android.Home(),
    login: (BuildContext context) => const Login(),
  };
}
