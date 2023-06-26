import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/data/services/firebase_service.dart';

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
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp();
    _firebaseService = FirebaseService();
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
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: greyColor),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              if (kIsWeb)
                // TODO use DI library
                ChangeNotifierProvider(
                  create: (_) => AuthProvider(_firebaseService),
                ),
              ChangeNotifierProvider(
                create: (_) => SongProvider(_firebaseService),
              ),
            ],
            builder: (context, child) {
              return MaterialApp(
                title: 'Your Music',
                theme: darkTheme,
                navigatorKey: navigatorKey,
                routes: Routes.routes,
                navigatorObservers: [routeObserver],
                onGenerateInitialRoutes: (initialRoute) {
                  // TODO after login, still can redirect to route login
                  if (kIsWeb) {
                    bool isLogin = context.read<AuthProvider>().isLogin;
                    if (!isLogin) {
                      return Navigator.defaultGenerateInitialRoutes(
                        Navigator.of(navigatorKey.currentContext!),
                        Routes.login,
                      );
                    }
                  }

                  return Navigator.defaultGenerateInitialRoutes(
                    Navigator.of(navigatorKey.currentContext!),
                    initialRoute,
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
