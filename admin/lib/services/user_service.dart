// services/user_service.dart (update)

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../utils/auth_utils.dart';

class UserService {
  late Dio _dio;

  Future<void> init() async {
    final token = await AuthUtils.getToken();
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<List<User>> getUsers() async {
    try {
      await init();
      final response = await _dio.get(ApiConfig.usersEndpoint);
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception("Failed to load users: ${e.toString()}");
    }
  }

  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      await init();
      await _dio.put(
        '${ApiConfig.usersEndpoint}/$userId',
        data: {"isAdmin": isAdmin},
      );
    } catch (e) {
      throw Exception("Failed to update role: ${e.toString()}");
    }
  }

  // Add new method to create a user
  Future<User> createUser(Map<String, dynamic> userData) async {
    try {
      await init();
      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: userData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(response.data);
      } else {
        throw Exception("Failed to create user");
      }
    } catch (e) {
      throw Exception("Failed to create user: ${e.toString()}");
    }
  }

  // Add method to update a user
  Future<User> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await init();
      final response = await _dio.put(
        '${ApiConfig.usersEndpoint}/$userId',
        data: userData,
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      throw Exception("Failed to update user: ${e.toString()}");
    }
  }

  // services/user_service.dart (update only the deleteUser method)

  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      await init();
      final response = await _dio.delete('${ApiConfig.usersEndpoint}/$userId');

      if (response.statusCode == 200) {
        return response.data; // Return the actual response data
      } else {
        throw Exception("Failed to delete user");
      }
    } catch (e) {
      throw Exception("Failed to delete user: ${e.toString()}");
    }
  }
}
