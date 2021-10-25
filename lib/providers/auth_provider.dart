import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/utils/routes/routes.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _isLogin = FirebaseService.instance.isLogged;
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  Future<void> login(BuildContext context, String username, String password) async {
    final isLogged = await FirebaseService.instance.login(username, password);
    if (isLogged) {
      _isLogin = true;
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }
}
