// view_models/category_view_model.dart

import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryViewModel with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get all categories
  Future<void> getCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _categoryService.init();
      _categories = await _categoryService.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Create a new category
  Future<bool> createCategory(Map<String, dynamic> categoryData) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _categoryService.init();
      await _categoryService.createCategory(categoryData);
      await getCategories(); // Refresh the list after creating a category
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

  // Update an existing category
  Future<bool> updateCategory(
    String categoryId,
    Map<String, dynamic> categoryData,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _categoryService.init();
      await _categoryService.updateCategory(categoryId, categoryData);
      await getCategories(); // Refresh the list after updating a category
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

  // Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _categoryService.init();
      final response = await _categoryService.deleteCategory(categoryId);
      await getCategories(); // Refresh the list after deleting a category

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
}
