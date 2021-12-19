import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/services/firebase_service.dart';

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

    if (isLogin == null) {
      _errorMessage = 'Error Occurred';
      return;
    }

    if (isLogin) {
      _isLogin = true;
      Navigator.pop(context);
    } else {
      _errorMessage = 'Username or Password incorrect';
    }
  }
}
