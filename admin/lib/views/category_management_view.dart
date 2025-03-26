// views/category_management_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/category_view_model.dart';
import '../models/category.dart';
import '../utils/auth_guard.dart';

class CategoryManagementView extends StatefulWidget {
  const CategoryManagementView({super.key});

  @override
  _CategoryManagementViewState createState() => _CategoryManagementViewState();
}

class _CategoryManagementViewState extends State<CategoryManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasAccess = await AuthGuard.checkAuth(context);
      if (hasAccess) {
        Provider.of<CategoryViewModel>(context, listen: false).getCategories();
      }
    });
  }

  // Method to show delete confirmation dialog
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete category "$categoryName"?',
                ),
                const SizedBox(height: 10),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final viewModel = Provider.of<CategoryViewModel>(
                  context,
                  listen: false,
                );

                try {
                  final success = await viewModel.deleteCategory(categoryId);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to delete category: ${viewModel.errorMessage}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show add/edit category dialog
  Future<void> _showCategoryDialog(
    BuildContext context, {
    Category? category,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(text: category?.icon ?? '');
    final colorController = TextEditingController(
      text: category?.color ?? '#ff5733',
    );

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      hintText: 'Enter category name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: iconController,
                    decoration: const InputDecoration(
                      labelText: 'Icon URL',
                      hintText: 'Enter icon URL',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: colorController,
                    decoration: const InputDecoration(
                      labelText: 'Color (Hex)',
                      hintText: 'Enter color in hex format (e.g., #ff5733)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a color';
                      }
                      // Basic hex color validation
                      if (!value.startsWith('#') || value.length != 7) {
                        return 'Please enter a valid hex color (e.g., #ff5733)';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(category == null ? 'Add' : 'Update'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final categoryData = {
                    'name': nameController.text,
                    'icon': iconController.text,
                    'color': colorController.text,
                  };

                  final viewModel = Provider.of<CategoryViewModel>(
                    context,
                    listen: false,
                  );
                  bool success = false;

                  try {
                    if (category == null) {
                      // Create new category
                      success = await viewModel.createCategory(categoryData);
                    } else {
                      // Update existing category
                      success = await viewModel.updateCategory(
                        category.id,
                        categoryData,
                      );
                    }

                    Navigator.of(dialogContext).pop();

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            category == null
                                ? 'Category created successfully'
                                : 'Category updated successfully',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed: ${viewModel.errorMessage}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.getCategories(),
            tooltip: 'Refresh Categories',
          ),
        ],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.categories.isEmpty
              ? const Center(child: Text("No categories found"))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Card-based list view
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.categories.length,
                        itemBuilder: (context, index) {
                          final category = viewModel.categories[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Name
                                      Expanded(
                                        child: Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      // Color
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                  category.color.replaceAll(
                                                    '#',
                                                    '0xFF',
                                                  ),
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            category.color,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // ID
                                  Text(
                                    "ID: ${category.id}",
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  // Icon
                                  if (category.icon.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.image, size: 14),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "Icon: ${category.icon}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Actions
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          _showCategoryDialog(
                                            context,
                                            category: category,
                                          );
                                        },
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('Edit'),
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _showDeleteConfirmation(
                                            context,
                                            category.id,
                                            category.name,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 16,
                                        ),
                                        label: const Text('Delete'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryDialog(context);
        },
        tooltip: 'Add New Category',
        child: const Icon(Icons.add),
      ),
    );
  }
}
