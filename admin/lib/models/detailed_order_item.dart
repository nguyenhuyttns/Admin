// models/detailed_order_item.dart
import 'package:admin/models/product.dart';

class DetailedOrderItem {
  final String id;
  final int quantity;
  final Product product;

  DetailedOrderItem({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory DetailedOrderItem.fromJson(Map<String, dynamic> json) {
    return DetailedOrderItem(
      id: json['_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      product: Product.fromJson(json['product'] ?? {}),
    );
  }
}
