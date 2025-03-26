// view_models/user_view_model.dart (update)

import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserViewModel with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _userService.init();
      _users = await _userService.getUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      await _userService.init();
      await _userService.updateUserRole(userId, isAdmin);
      await getUsers(); // Refresh the list after update
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createUser(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _userService.init();
      await _userService.createUser(userData);
      await getUsers(); // Refresh the list after creating a user
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Add method to update a user
  Future<bool> updateUser(String userId, Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _userService.init();
      await _userService.updateUser(userId, userData);
      await getUsers(); // Refresh the list after updating a user
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _userService.init();
      final response = await _userService.deleteUser(userId);
      await getUsers(); // Refresh the list after deleting a user

      _isLoading = false;
      notifyListeners();

      // Check if the response contains success: true
      return response['success'] == true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
