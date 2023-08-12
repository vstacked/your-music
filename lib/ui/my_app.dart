import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/data/services/notification_service.dart';

import '../constants/app_theme.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/song_provider.dart';
import '../utils/routes/observer.dart';
import '../utils/routes/routes.dart';
import 'android/home/favorite.dart';

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

    final apps = Firebase.apps;
    if (apps.isNotEmpty) {
      _initialization = Future.value(apps.first);
    } else {
      _initialization = Firebase.initializeApp();
    }
  }

  FirebaseService _getFirebaseService() {
    final _firestore = FirebaseFirestore.instance;
    final _storage = FirebaseStorage.instance;
    final _messaging = FirebaseMessaging.instance;
    final _auth = FirebaseAuth.instance;
    final _notification = NotificationService.instance;

    return FirebaseService(
      firestore: _firestore,
      storage: _storage,
      messaging: _messaging,
      auth: _auth,
      notification: _notification,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
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
          final _firebaseService = _getFirebaseService();

          return MultiProvider(
            providers: [
              if (kIsWeb)
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
                onGenerateRoute: (settings) {
                  if (settings.name == Routes.favorite) {
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (_, __, ___) => const Favorite(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) => CupertinoPageTransition(
                        primaryRouteAnimation: animation,
                        secondaryRouteAnimation: secondaryAnimation,
                        child: child,
                        linearTransition: true,
                      ),
                    );
                  }
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
