// services/product_service.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/product.dart';
import '../utils/auth_utils.dart';

class ProductService {
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

  // Get all products
  Future<List<Product>> getProducts({String? categoryId}) async {
    try {
      await init();
      final response = await _dio.get(
        ApiConfig.productsEndpoint,
        queryParameters: categoryId != null ? {'categories': categoryId} : null,
      );

      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      throw Exception("Failed to load products: ${e.toString()}");
    }
  }

  // Get product by ID
  Future<Product> getProductById(String productId) async {
    try {
      await init();
      final response = await _dio.get(
        '${ApiConfig.productsEndpoint}/$productId',
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Failed to load product: ${e.toString()}");
    }
  }

  // Create a new product with image upload
  Future<Product> createProduct(
    Map<String, dynamic> productData,
    File? imageFile,
  ) async {
    try {
      await init();

      FormData formData = FormData();

      // Add product data
      for (var entry in productData.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }

      // Add image if provided
      if (imageFile != null) {
        String fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          ),
        );
      }

      final response = await _dio.post(
        ApiConfig.productsEndpoint,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(response.data);
      } else {
        throw Exception("Failed to create product");
      }
    } catch (e) {
      throw Exception("Failed to create product: ${e.toString()}");
    }
  }

  // services/product_service.dart (cập nhật phương thức updateProduct)

  Future<Product> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      await init();

      // Sử dụng JSON để cập nhật thông tin cơ bản
      final response = await _dio.put(
        '${ApiConfig.productsEndpoint}/$productId',
        data: productData,
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception("Failed to update product");
      }
    } catch (e) {
      throw Exception("Failed to update product: ${e.toString()}");
    }
  }

  // Upload multiple gallery images
  Future<Product> uploadGalleryImages(
    String productId,
    List<File> imageFiles,
  ) async {
    try {
      await init();

      FormData formData = FormData();

      // Add multiple images
      for (var imageFile in imageFiles) {
        String fileName = imageFile.path.split('/').last;
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: fileName,
              contentType: MediaType('image', fileName.split('.').last),
            ),
          ),
        );
      }

      final response = await _dio.put(
        '${ApiConfig.productsEndpoint}/gallery-images/$productId',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception("Failed to upload gallery images");
      }
    } catch (e) {
      throw Exception("Failed to upload gallery images: ${e.toString()}");
    }
  }

  // Delete a product
  Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      await init();
      final response = await _dio.delete(
        '${ApiConfig.productsEndpoint}/$productId',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      throw Exception("Failed to delete product: ${e.toString()}");
    }
  }

  // Get product count
  Future<int> getProductCount() async {
    try {
      await init();
      final response = await _dio.get(
        '${ApiConfig.productsEndpoint}/get/count',
      );

      if (response.statusCode == 200) {
        return response.data['productCount'] ?? 0;
      } else {
        throw Exception("Failed to get product count");
      }
    } catch (e) {
      throw Exception("Failed to get product count: ${e.toString()}");
    }
  }

  // Get featured products
  Future<List<Product>> getFeaturedProducts(int count) async {
    try {
      await init();
      final response = await _dio.get(
        '${ApiConfig.productsEndpoint}/get/featured/$count',
      );

      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      throw Exception("Failed to load featured products: ${e.toString()}");
    }
  }
}
