import 'package:flutter/material.dart';
import 'package:your_music/ui/web/home/home.dart';
import 'package:your_music/ui/web/login/login.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => const Home(),
    login: (BuildContext context) => const Login(),
  };
}
