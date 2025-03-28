// models/order.dart
import 'package:admin/models/user.dart';

class Order {
  final String id;
  final List<String>
  orderItemIds; // Lưu ý rằng API trả về mảng ID của orderItems
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

  Order({
    required this.id,
    required this.orderItemIds,
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

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? json['_id'] ?? '',
      orderItemIds:
          (json['orderItems'] as List<dynamic>)
              .map((item) => item.toString())
              .toList(),
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
