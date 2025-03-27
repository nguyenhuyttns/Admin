// models/product.dart

import 'package:admin/config/api_config.dart';
import 'package:admin/models/category.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String richDescription;
  final String image;
  final List<String> images;
  final String brand;
  final double price;
  final Category category;
  final int countInStock;
  final double rating;
  final int numReviews;
  final bool isFeatured;
  final DateTime dateCreated;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.richDescription,
    required this.image,
    required this.images,
    required this.brand,
    required this.price,
    required this.category,
    required this.countInStock,
    required this.rating,
    required this.numReviews,
    required this.isFeatured,
    required this.dateCreated,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      richDescription: json['richDescription'] ?? '',
      image: ApiConfig.fixImageUrl(json['image'] ?? ''),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((img) => ApiConfig.fixImageUrl(img.toString()))
              .toList() ??
          [],
      brand: json['brand'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      category:
          json['category'] != null
              ? Category.fromJson(json['category'])
              : Category(id: '', name: '', icon: '', color: ''),
      countInStock: json['countInStock'] ?? 0,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      numReviews: json['numReviews'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      dateCreated:
          json['dateCreated'] != null
              ? DateTime.parse(json['dateCreated'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'richDescription': richDescription,
      'brand': brand,
      'price': price,
      'category': category.id,
      'countInStock': countInStock,
      'rating': rating,
      'numReviews': numReviews,
      'isFeatured': isFeatured,
    };
  }
}
