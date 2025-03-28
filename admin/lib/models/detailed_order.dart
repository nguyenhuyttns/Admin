// models/detailed_order.dart
import 'package:admin/models/detailed_order_item.dart';
import 'package:admin/models/user.dart';

class DetailedOrder {
  final String id;
  final List<DetailedOrderItem> orderItems;
  final String shippingAddress1;
  final String shippingAddress2;
  final String city;
  final String zip;
  final String country;
  final String phone;
  final String status;
  final double totalPrice;
  final User user;
  final DateTime dateOrdered;

  DetailedOrder({
    required this.id,
    required this.orderItems,
    required this.shippingAddress1,
    required this.shippingAddress2,
    required this.city,
    required this.zip,
    required this.country,
    required this.phone,
    required this.status,
    required this.totalPrice,
    required this.user,
    required this.dateOrdered,
  });

  factory DetailedOrder.fromJson(Map<String, dynamic> json) {
    return DetailedOrder(
      id: json['_id'] ?? json['id'] ?? '',
      orderItems:
          (json['orderItems'] as List<dynamic>?)
              ?.map((item) => DetailedOrderItem.fromJson(item))
              .toList() ??
          [],
      shippingAddress1: json['shippingAddress1'] ?? '',
      shippingAddress2: json['shippingAddress2'] ?? '',
      city: json['city'] ?? '',
      zip: json['zip'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      totalPrice:
          json['totalPrice'] != null
              ? (json['totalPrice'] as num).toDouble()
              : 0.0,
      user:
          json['user'] != null
              ? User.fromJson(json['user'])
              : User(
                id: '',
                name: '',
                email: '',
                phone: '',
                isAdmin: false,
                street: '',
                apartment: '',
                zip: '',
                city: '',
                country: '',
              ),
      dateOrdered:
          json['dateOrdered'] != null
              ? DateTime.parse(json['dateOrdered'])
              : DateTime.now(),
    );
  }
}
