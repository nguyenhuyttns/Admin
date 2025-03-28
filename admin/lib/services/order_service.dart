// services/order_service.dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/order.dart';
import '../utils/auth_utils.dart';

class OrderService {
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

  // Lấy tất cả đơn hàng
  Future<List<Order>> getOrders() async {
    try {
      await init();
      final response = await _dio.get(ApiConfig.ordersEndpoint);

      return (response.data as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      throw Exception("Failed to load orders: ${e.toString()}");
    }
  }

  // Add this new method to get order details by ID
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      await init();
      final response = await _dio.get('${ApiConfig.ordersEndpoint}/$orderId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load order details");
      }
    } catch (e) {
      throw Exception("Failed to load order details: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      await init();
      final response = await _dio.put(
        '${ApiConfig.ordersEndpoint}/$orderId',
        data: {"status": status},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to update order status");
      }
    } catch (e) {
      throw Exception("Failed to update order status: ${e.toString()}");
    }
  }
}
