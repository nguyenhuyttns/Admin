// view_models/order_view_model.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import '../models/detailed_order.dart';

class OrderViewModel with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  DetailedOrder? _selectedOrder;
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  String _errorMessage = '';

  List<Order> get orders => _orders;
  DetailedOrder? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoadingDetails;
  String get errorMessage => _errorMessage;

  // Lấy tất cả đơn hàng
  Future<void> getOrders() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _orderService.init();
      _orders = await _orderService.getOrders();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Add this method to get detailed order information
  Future<DetailedOrder?> getOrderDetails(String orderId) async {
    _isLoadingDetails = true;
    _errorMessage = '';
    _selectedOrder = null;
    notifyListeners();

    try {
      final orderData = await _orderService.getOrderById(orderId);
      _selectedOrder = DetailedOrder.fromJson(orderData);
      _isLoadingDetails = false;
      notifyListeners();
      return _selectedOrder;
    } catch (e) {
      _isLoadingDetails = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final orderData = await _orderService.updateOrderStatus(orderId, status);

      // Cập nhật trạng thái trong danh sách orders
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final updatedOrder = _orders[index];
        _orders[index] = Order(
          id: updatedOrder.id,
          orderItemIds: updatedOrder.orderItemIds,
          shippingAddress1: updatedOrder.shippingAddress1,
          shippingAddress2: updatedOrder.shippingAddress2,
          city: updatedOrder.city,
          zip: updatedOrder.zip,
          country: updatedOrder.country,
          phone: updatedOrder.phone,
          status: status, // Cập nhật trạng thái mới
          totalPrice: updatedOrder.totalPrice,
          user: updatedOrder.user,
          dateOrdered: updatedOrder.dateOrdered,
        );
      }

      // Đặt lại selectedOrder nếu đang xem chi tiết đơn hàng này
      if (_selectedOrder != null && _selectedOrder!.id == orderId) {
        _selectedOrder = null;
      }

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
}
