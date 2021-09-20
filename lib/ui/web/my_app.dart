import 'package:flutter/material.dart';
import 'package:your_music/constants/app_theme.dart';
import 'package:your_music/utils/routes/observer.dart';
import 'package:your_music/utils/routes/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Music',
      theme: darkTheme,
      navigatorKey: navigatorKey,
      routes: Routes.routes,
      navigatorObservers: [Observer()],
    );
  }
}
