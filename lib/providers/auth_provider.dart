import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  //

  bool _isObscured = true;
  bool get isObscured => _isObscured;
  void togglePassword() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    debugPrint('$username - $password');
  }
}
