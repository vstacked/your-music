import 'package:flutter/material.dart';

import '../data/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;

  AuthProvider(this._firebaseService) {
    _isLogin = _firebaseService.isLogin;
  }

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isFormValidate = false;

  bool get isFormValidate => _isFormValidate;

  String _username = '', _password = '';

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool get isValidated =>
      _isFormValidate &&
      !_isLoading &&
      _username.isNotEmpty &&
      _password.isNotEmpty;

  Future<bool> login() async {
    if (!_isFormValidate) return false;

    _isLoading = true;

    _errorMessage = '';
    notifyListeners();

    final isLogin = await _firebaseService.login(_username, _password);

    _isLoading = false;

    if (isLogin == null) {
      _errorMessage = 'Error Occurred';
      notifyListeners();
      return false;
    }

    if (isLogin) {
      _isLogin = true;
      return true;
    } else {
      _errorMessage = 'Username or Password incorrect';
      notifyListeners();
      return false;
    }
  }

  void setFormValidated(bool value) {
    _isFormValidate = value;
    notifyListeners();
  }
}
