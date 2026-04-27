import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool isLoading = false;
  String? errorMessage;

  bool get isLoggedIn => _token != null;
  String? get token => _token;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final auth = await AuthService.login(username, password);
      _token = auth.token;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
