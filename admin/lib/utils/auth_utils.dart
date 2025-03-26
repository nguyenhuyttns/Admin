// utils/auth_utils.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthUtils {
  static const String _tokenKey = 'auth_token';

  // Save the token to SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve the token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove the token from SharedPreferences (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Check if the user is an admin
  static Future<bool> isAdmin() async {
    try {
      final token = await getToken(); // Lấy token từ SharedPreferences
      if (token == null) return false;

      // Giải mã token để kiểm tra quyền admin
      final payload = Jwt.parseJwt(token);
      return payload['isAdmin'] ?? false; // Trả về true nếu isAdmin = true
    } catch (e) {
      return false; // Nếu có lỗi, coi như không phải admin
    }
  }
}
