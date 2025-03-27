// view_models/product_view_model.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../config/api_config.dart';

class ProductViewModel with ChangeNotifier {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final Dio _dio = Dio();

  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get all products
  Future<void> getProducts({String? categoryId}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _productService.init();
      _products = await _productService.getProducts(categoryId: categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get all categories for product form
  Future<void> getCategories() async {
    try {
      await _categoryService.init();
      _categories = await _categoryService.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  // In view_models/product_view_model.dart

  Future<bool> createProduct(
    Map<String, dynamic> productData,
    File imageFile,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Ensure we're using the properly configured Dio instance
      await _productService.init();

      // Create form data
      FormData formData = FormData();

      // Add text fields
      for (var entry in productData.entries) {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }

      // Add image
      String fileName = imageFile.path.split('/').last;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(imageFile.path, filename: fileName),
        ),
      );

      // Use the product service to make the API call, not the local Dio instance
      final product = await _productService.createProduct(
        productData,
        imageFile,
      );

      // Refresh the product list
      await getProducts();
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

  Future<bool> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _productService.init();

      // Gọi phương thức cập nhật từ service
      final product = await _productService.updateProduct(
        productId,
        productData,
      );

      // Cập nhật danh sách sản phẩm
      await getProducts();

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

  // Delete a product
  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _productService.init();
      final response = await _productService.deleteProduct(productId);
      await getProducts(); // Refresh the list after deleting a product

      _isLoading = false;
      notifyListeners();

      // Check if the response contains success: true
      return response['success'] == true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Filter products by category
  Future<void> filterByCategory(String categoryId) async {
    await getProducts(categoryId: categoryId);
  }

  // Clear category filter
  Future<void> clearFilter() async {
    await getProducts();
  }
}
