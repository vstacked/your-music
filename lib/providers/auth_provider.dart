import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:your_music/data/services/firebase_service.dart';
import 'package:your_music/utils/routes/routes.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _isLogin = _auth.currentUser != null;
  }

  late FirebaseAuth _auth;

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  Future<void> login(BuildContext context, String username, String password) async {
    try {
      final data = await FirebaseService.instance.adminAuth();
      if (data.isEmpty) return;

      if (username == data['username'] && password == data['password']) {
        await _auth.signInAnonymously();
        _isLogin = true;
        Navigator.pushReplacementNamed(context, Routes.home);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
