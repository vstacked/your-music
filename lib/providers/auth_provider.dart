import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/utils/routes/routes.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _isLogin = FirebaseService.instance.isLogin;
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> login(BuildContext context, String username, String password) async {
    _errorMessage = '';

    final isLogin = await FirebaseService.instance.login(username, password);
    if (isLogin) {
      _isLogin = true;
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      _errorMessage = 'Username or Password incorrect';
    }
  }
}
