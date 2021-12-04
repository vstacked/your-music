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
                  bool isLogin = context.read<AuthProvider>().isLogin;
                  if (kIsWeb && !isLogin) {
                    return Navigator.defaultGenerateInitialRoutes(
                        Navigator.of(navigatorKey.currentContext!), Routes.login);
                  }
                  return Navigator.defaultGenerateInitialRoutes(
                      Navigator.of(navigatorKey.currentContext!), initialRoute);
                },
                // onGenerateRoute: (settings) {
                //   debugPrint(settings.name);
                // if (kIsWeb) {
                //   bool isLogin = context.read<AuthProvider>().isLogin;
                //   if (settings.name != Routes.login && !isLogin) {
                //     return _CustomRoute(builder: (_) => const Login(), settings: settings);
                //   } else if (settings.name == Routes.login && isLogin) {
                //     return _CustomRoute(builder: (_) => const Home(), settings: settings);
                //   }
                // }
                // },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _CustomRoute<T> extends MaterialPageRoute<T> {
  _CustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
          BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
      child;
}
