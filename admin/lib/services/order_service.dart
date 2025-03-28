// services/order_service.dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/order.dart';
import '../models/order_item.dart';
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
      print("API Response: ${response.data}"); // Thêm log để debug

      return (response.data as List)
          .map((order) => Order.fromJson(order))
          .toList();
    } catch (e) {
      print("Service error: ${e.toString()}"); // Thêm log để debug
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
      print("Error fetching order details: ${e.toString()}");
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
      print("Error updating order status: ${e.toString()}");
      throw Exception("Failed to update order status: ${e.toString()}");
    }
  }
}
