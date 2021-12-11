import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/song_provider.dart';
import '../utils/routes/observer.dart';
import '../utils/routes/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = Observer.route;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<FirebaseApp> _initialization;
  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
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
              if (kIsWeb) ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => SongProvider()),
            ],
            builder: (context, child) {
              return MaterialApp(
                title: 'Your Music',
                theme: darkTheme,
                navigatorKey: navigatorKey,
                routes: Routes.routes,
                navigatorObservers: [routeObserver],
                onGenerateInitialRoutes: (initialRoute) {
                  if (kIsWeb) {
                    bool isLogin = context.read<AuthProvider>().isLogin;
                    if (!isLogin) {
                      return Navigator.defaultGenerateInitialRoutes(
                          Navigator.of(navigatorKey.currentContext!), Routes.login);
                    }
                  }
                  return Navigator.defaultGenerateInitialRoutes(
                      Navigator.of(navigatorKey.currentContext!), initialRoute);
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
