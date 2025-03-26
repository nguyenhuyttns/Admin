// services/user_service.dart

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../utils/auth_utils.dart';

class UserService {
  late Dio _dio;

  Future<void> init() async {
    final token = await AuthUtils.getToken(); // Lấy token từ SharedPreferences
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token', // Thêm token vào header
        },
      ),
    );
  }

  Future<List<User>> getUsers() async {
    try {
      await init(); // Khởi tạo Dio với header chứa token
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
      await init(); // Khởi tạo Dio với header chứa token
      await _dio.put(
        '${ApiConfig.usersEndpoint}/$userId',
        data: {"isAdmin": isAdmin},
      );
    } catch (e) {
      throw Exception("Failed to update role: ${e.toString()}");
    }
  }
}
