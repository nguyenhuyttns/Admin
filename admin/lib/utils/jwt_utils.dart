// utils/jwt_utils.dart
import 'package:jwt_decode/jwt_decode.dart';

class JwtUtils {
  static bool isAdmin(String token) {
    try {
      final payload = Jwt.parseJwt(token);
      return payload['isAdmin'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
