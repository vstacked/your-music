import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:your_music/providers/auth_provider.dart';
import 'package:your_music/ui/web/home/home.dart';
import 'package:your_music/ui/web/login/login.dart';
import 'package:your_music/ui/web/my_app.dart';
import 'package:provider/provider.dart';
import 'package:your_music/utils/routes/routes.dart';

// TODO fix bugs routes
class Observer extends NavigatorObserver {
  final List<Route<dynamic>> _routeStack = [];

  void _routeHistory() => log(_routeStack.map((e) => e.settings.name).toList().toString());

  void _pushRemoveWithoutAnimation(Widget child, {required String routes, required String until}) {
    Future.microtask(() {
      navigator!.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => child,
          transitionDuration: Duration.zero,
          settings: RouteSettings(name: routes),
        ),
        // (_) => false,
        ModalRoute.withName(until),
      );
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    bool isLogin = navigatorKey.currentContext!.read<AuthProvider>().isLogin;

    if (route.settings.name != Routes.login && !isLogin) {
      _pushRemoveWithoutAnimation(const Login(), routes: Routes.login, until: Routes.home);
    } else if (route.settings.name == Routes.login && isLogin) {
      _pushRemoveWithoutAnimation(const Home(), routes: Routes.home, until: Routes.login);
    }

    _routeStack.add(route);
    _routeHistory();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.removeLast();
    _routeHistory();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.removeLast();
    _routeHistory();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _routeStack.removeLast();
    _routeStack.add(newRoute!);
    _routeHistory();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
