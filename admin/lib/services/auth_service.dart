// services/auth_service.dart

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../utils/auth_utils.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        // Extract user email and token from the response
        final userEmail = response.data['user'];
        final token = response.data['token'];

        // Save the token to SharedPreferences
        await AuthUtils.saveToken(token);

        // Return the user email and token
        return {'email': userEmail, 'token': token};
      } else {
        throw Exception("Login failed");
      }
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }
}
