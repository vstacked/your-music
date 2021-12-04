import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:developer' as dev;

// TODO fix bugs routes
// class Observer extends NavigatorObserver {
//   final List<Route<dynamic>> _routeStack = [];

//   void _routeHistory() => log(_routeStack.map((e) => e.settings.name).toList().toString());

//   void _pushRemoveWithoutAnimation(Widget child, {required String routes}) {
//     Future.microtask(() {
//       navigator!.pushAndRemoveUntil(
//         PageRouteBuilder(
//           pageBuilder: (_, __, ___) => child,
//           transitionDuration: Duration.zero,
//           settings: RouteSettings(name: routes),
//         ),
//         (_) => false,
//       );
//     });
//   }

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     if (kIsWeb) {
//       bool isLogin = navigatorKey.currentContext!.read<AuthProvider>().isLogin;

//       if (route.settings.name != Routes.login && !isLogin) {
//         _pushRemoveWithoutAnimation(const Login(), routes: Routes.login);
//       } else if (route.settings.name == Routes.login && isLogin) {
//         _pushRemoveWithoutAnimation(const Home(), routes: Routes.home);
//       }
//     }

//     _routeStack.add(route);
//     _routeHistory();
//     super.didPush(route, previousRoute);
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _routeStack.removeLast();
//     _routeHistory();
//     super.didPop(route, previousRoute);
//   }

//   @override
//   void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _routeStack.removeLast();
//     _routeHistory();
//     super.didRemove(route, previousRoute);
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     _routeStack.removeLast();
//     _routeStack.add(newRoute!);
//     _routeHistory();
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//   }
// }

class Observer {
  const Observer._();
  static final _RouteObserver route = _RouteObserver();
}

class _RouteObserver extends RouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _navStack.push(route.settings.name!);
    _logStack();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _navStack.pop();
    _logStack();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _navStack.remove(route.settings.name!);
    _logStack();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _navStack.replace(newRoute!.settings.name!, oldRoute!.settings.name!);
    _logStack();
  }

  final NavStack<String> _navStack = NavStack<String>();
  NavStack<String> get navStack => _navStack;

  void _logStack() {
    dev.log(navStack.fetchAll().toString(), name: 'Routes');
  }
}

class NavStack<T> implements _NavStack<T> {
  final ListQueue<T> _internal = ListQueue();

  @override
  void get clear => _internal.clear();

  int get length => _internal.length;

  @override
  List<T> fetchAll() {
    final _list = <T>[];

    for (var i = 0; i < length; i++) {
      _list.add(_internal.elementAt(i));
    }
    return _list;
  }

  @override
  void pop() {
    _internal.removeLast();
  }

  @override
  void push(T val) {
    _internal.addLast(val);
  }

  @override
  T top() => _internal.last;

  @override
  void remove(T val) {
    _internal.removeWhere((element) => element == val);
  }

  @override
  void replace(T newRoute, T oldRoute) {
    _internal.removeWhere((element) => element == oldRoute);
    _internal.add(newRoute);
  }
}

abstract class _NavStack<T> {
  void push(T val) {}
  void pop() {}
  void remove(T val) {}
  void replace(T newRoute, T oldRoute) {}
  T top();
  List<T> fetchAll();
  void get clear {}
}
