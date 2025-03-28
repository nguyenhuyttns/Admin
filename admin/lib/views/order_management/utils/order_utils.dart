// views/order_management/utils/order_utils.dart
import 'package:flutter/material.dart';
import '../../../models/order.dart';
import '../../../models/detailed_order.dart';

class OrderUtils {
  // Get color for order status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processed':
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Format address for display
  static String formatAddress(Order order) {
    List<String> parts = [];
    if (order.shippingAddress1.isNotEmpty) parts.add(order.shippingAddress1);
    if (order.shippingAddress2.isNotEmpty) parts.add(order.shippingAddress2);
    if (order.city.isNotEmpty) parts.add(order.city);
    if (order.zip.isNotEmpty) parts.add("ZIP: ${order.zip}");
    if (order.country.isNotEmpty) parts.add(order.country);

    return parts.join(', ');
  }

  // Format address for detailed order
  static String formatDetailedAddress(DetailedOrder order) {
    List<String> parts = [];
    if (order.shippingAddress1.isNotEmpty) parts.add(order.shippingAddress1);
    if (order.shippingAddress2.isNotEmpty) parts.add(order.shippingAddress2);
    if (order.city.isNotEmpty) parts.add(order.city);
    if (order.zip.isNotEmpty) parts.add("ZIP: ${order.zip}");
    if (order.country.isNotEmpty) parts.add(order.country);

    return parts.join(', ');
  }

  // Filter orders based on search query and status
  static List<Order> filterOrders(
    List<Order> orders,
    String query,
    String? status,
  ) {
    var filteredList = orders;

    // Filter by status if selected
    if (status != null && status.isNotEmpty) {
      filteredList =
          filteredList
              .where(
                (order) => order.status.toLowerCase() == status.toLowerCase(),
              )
              .toList();
    }

    // Filter by search query
    if (query.isNotEmpty) {
      query = query.toLowerCase();
      filteredList =
          filteredList.where((order) {
            return order.id.toLowerCase().contains(query) ||
                order.user.name.toLowerCase().contains(query) ||
                order.shippingAddress1.toLowerCase().contains(query) ||
                order.city.toLowerCase().contains(query) ||
                order.country.toLowerCase().contains(query) ||
                order.phone.toLowerCase().contains(query);
          }).toList();
    }

    return filteredList;
  }

  // Get unique statuses from orders
  static List<String> getUniqueStatuses(List<Order> orders) {
    return orders.map((order) => order.status.toLowerCase()).toSet().toList();
  }
}
