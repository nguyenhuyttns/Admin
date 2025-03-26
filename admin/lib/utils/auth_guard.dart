// utils/auth_guard.dart
import 'package:flutter/material.dart';
import 'auth_utils.dart';

class AuthGuard {
  static Future<bool> checkAuth(BuildContext context) async {
    final isAdmin = await AuthUtils.isAdmin(); // Kiểm tra quyền admin
    if (!isAdmin) {
      // Redirect to login nếu không phải admin
      Navigator.of(context).pushReplacementNamed('/');
      return false;
    }
    return true; // Trả về true nếu là admin
  }
}
