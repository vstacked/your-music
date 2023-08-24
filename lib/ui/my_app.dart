import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/data/services/notification_service.dart';
import 'package:your_music/firebase_options.dart';

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
  State<MyApp> createState() => _MyAppState();
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
      _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
  }

  Future<FirebaseService> _getFirebaseService() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;
    final messaging = FirebaseMessaging.instance;
    final auth = FirebaseAuth.instance;
    final notification = NotificationService.instance;
    final crashlytics = FirebaseCrashlytics.instance;
    final remoteConfig = FirebaseRemoteConfig.instance;
    final sharedPreferences = await SharedPreferences.getInstance();

    const useLocalEnvironment = false;
    if (useLocalEnvironment) {
      // const host = kIsWeb ? '127.0.0.1' : '10.0.2.2';
      const host = '127.0.0.1';
      const setting = Settings(persistenceEnabled: true);
      firestore.useFirestoreEmulator(host, 8080);
      firestore.settings = setting;
      storage.useStorageEmulator(host, 9199);
    }

    return FirebaseService(
      firestore: firestore,
      storage: storage,
      messaging: messaging,
      auth: auth,
      notification: notification,
      crashlytics: crashlytics,
      remoteConfig: remoteConfig,
      sharedPreferences: sharedPreferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            theme: buildTheme(),
            title: 'Your Music',
            home: Scaffold(
              body: Center(
                child: Text(
                  'Something Went Wrong..',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: _getFirebaseService(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MultiProvider(
                  providers: [
                    if (kIsWeb)
                      ChangeNotifierProvider(
                        create: (_) => AuthProvider(snapshot.data!),
                      ),
                    ChangeNotifierProvider(
                      create: (_) => SongProvider(snapshot.data!),
                    ),
                  ],
                  builder: (context, child) {
                    final isLogin = kIsWeb ? context.select((AuthProvider p) => p.isLogin) : false;
                    return MaterialApp(
                      title: 'Your Music',
                      theme: buildTheme(),
                      navigatorKey: navigatorKey,
                      routes: Routes.routes,
                      navigatorObservers: [routeObserver],
                      onGenerateInitialRoutes: (initialRoute) {
                        if (kIsWeb) {
                          return Navigator.defaultGenerateInitialRoutes(
                            Navigator.of(navigatorKey.currentContext!),
                            !isLogin ? Routes.login : Routes.home,
                          );
                        }

                        return Navigator.defaultGenerateInitialRoutes(
                          Navigator.of(navigatorKey.currentContext!),
                          initialRoute,
                        );
                      },
                      onGenerateRoute: (settings) {
                        if (kIsWeb) {
                          return MaterialPageRoute(builder: Routes.routes[!isLogin ? Routes.login : Routes.home]!);
                        } else if (settings.name == Routes.favorite) {
                          return PageRouteBuilder(
                            settings: settings,
                            pageBuilder: (_, __, ___) => const Favorite(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                                CupertinoPageTransition(
                              primaryRouteAnimation: animation,
                              secondaryRouteAnimation: secondaryAnimation,
                              linearTransition: true,
                              child: child,
                            ),
                          );
                        }

                        return null;
                      },
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
