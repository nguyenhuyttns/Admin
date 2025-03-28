// models/order_item.dart
import 'package:admin/models/category.dart';
import 'package:admin/models/product.dart';

class OrderItem {
  final String id;
  final int quantity;
  final Product product;

  OrderItem({required this.id, required this.quantity, required this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      product:
          json['product'] != null
              ? Product.fromJson(json['product'])
              : Product(
                id: '',
                name: '',
                description: '',
                richDescription: '',
                image: '',
                images: [],
                brand: '',
                price: 0,
                category: Category(id: '', name: '', icon: '', color: ''),
                countInStock: 0,
                rating: 0,
                numReviews: 0,
                isFeatured: false,
                dateCreated: DateTime.now(),
              ),
    );
  }
}
