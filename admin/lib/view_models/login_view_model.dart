// view_models/login_view_model.dart
import 'package:admin/utils/jwt_utils.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Call the login API
      final response = await _authService.login(email, password);
      final String token = response['token'];

      // Check if the user is an admin
      final bool isAdmin = JwtUtils.isAdmin(token);

      _isLoading = false;
      notifyListeners();

      return isAdmin; // Return true if the user is an admin
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
