import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/app_theme.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/providers/auth_provider.dart';
import 'package:your_music/providers/song_provider.dart';
import 'package:your_music/utils/routes/observer.dart';
import 'package:your_music/utils/routes/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            theme: darkTheme,
            home: Scaffold(
              body: Center(
                child: Text(
                  'Something Went Wrong..',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => SongProvider()),
            ],
            child: MaterialApp(
              title: 'Your Music',
              theme: darkTheme,
              navigatorKey: navigatorKey,
              routes: Routes.routes,
              navigatorObservers: [Observer()],
            ),
          );
        }

        return MaterialApp(theme: darkTheme, home: const Scaffold(body: Center(child: CircularProgressIndicator())));
      },
    );
  }
}
