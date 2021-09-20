import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:your_music/utils/routes/routes.dart';

class AuthProvider extends ChangeNotifier {
  //
  bool _isLogin = false;
  bool get isLogin => _isLogin;

  Future<void> login(BuildContext context, String username, String password) async {
    debugPrint('$username - $password');
    _isLogin = true;
    Navigator.pushReplacementNamed(context, Routes.home);
    notifyListeners();
  }
}
