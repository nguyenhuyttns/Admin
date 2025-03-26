// view_models/user_view_model.dart
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserViewModel with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> getUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.init(); // Khởi tạo UserService
      _users = await _userService.getUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }

  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      await _userService.init(); // Khởi tạo UserService
      await _userService.updateUserRole(userId, isAdmin);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
