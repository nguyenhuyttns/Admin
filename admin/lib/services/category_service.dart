// services/category_service.dart

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/category.dart';
import '../utils/auth_utils.dart';

class CategoryService {
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

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      await init();
      final response = await _dio.get(ApiConfig.categoriesEndpoint);

      return (response.data as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } catch (e) {
      throw Exception("Failed to load categories: ${e.toString()}");
    }
  }

  // Create a new category
  Future<Category> createCategory(Map<String, dynamic> categoryData) async {
    try {
      await init();
      final response = await _dio.post(
        ApiConfig.categoriesEndpoint,
        data: categoryData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Category.fromJson(response.data);
      } else {
        throw Exception("Failed to create category");
      }
    } catch (e) {
      throw Exception("Failed to create category: ${e.toString()}");
    }
  }

  // Update an existing category
  Future<Category> updateCategory(
    String categoryId,
    Map<String, dynamic> categoryData,
  ) async {
    try {
      await init();
      final response = await _dio.put(
        '${ApiConfig.categoriesEndpoint}/$categoryId',
        data: categoryData,
      );

      if (response.statusCode == 200) {
        return Category.fromJson(response.data);
      } else {
        throw Exception("Failed to update category");
      }
    } catch (e) {
      throw Exception("Failed to update category: ${e.toString()}");
    }
  }

  // Delete a category
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      await init();
      final response = await _dio.delete(
        '${ApiConfig.categoriesEndpoint}/$categoryId',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to delete category");
      }
    } catch (e) {
      throw Exception("Failed to delete category: ${e.toString()}");
    }
  }
}
