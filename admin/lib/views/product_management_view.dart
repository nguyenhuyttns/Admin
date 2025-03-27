// views/product_management_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/product_view_model.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../utils/auth_guard.dart';
import '../config/api_config.dart';
import 'add_product_view.dart';
import 'edit_product_view.dart';

class ProductManagementView extends StatefulWidget {
  const ProductManagementView({super.key});

  @override
  _ProductManagementViewState createState() => _ProductManagementViewState();
}

class _ProductManagementViewState extends State<ProductManagementView> {
  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasAccess = await AuthGuard.checkAuth(context);
      if (hasAccess) {
        final viewModel = Provider.of<ProductViewModel>(context, listen: false);
        await viewModel.getCategories();
        await viewModel.getProducts();
      }
    });
  }

  // Method to show delete confirmation dialog
  Future<void> _showDeleteConfirmation(
    BuildContext context,
    String productId,
    String productName,
  ) async {
    // Store the scaffold messenger before showing the dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Confirm Delete'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete product "$productName"?'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red[700],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'This action cannot be undone.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
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
            ElevatedButton.icon(
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                // Close the dialog first
                Navigator.of(dialogContext).pop();

                final viewModel = Provider.of<ProductViewModel>(
                  context,
                  listen: false,
                );

                try {
                  final success = await viewModel.deleteProduct(productId);

                  if (success) {
                    // Use the stored scaffold messenger
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Product deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Use the stored scaffold messenger
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to delete product: ${viewModel.errorMessage}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  // Use the stored scaffold messenger
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        );
      },
    );
  }

  // Filter products based on search query
  List<Product> _filterProducts(List<Product> products, String query) {
    if (query.isEmpty) {
      return products;
    }

    query = query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
    final filteredProducts = _filterProducts(viewModel.products, _searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.getProducts(),
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductView(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Category filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategoryId == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                            viewModel.clearFilter();
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.blue[100],
                        checkmarkColor: Colors.blue[800],
                      ),
                      const SizedBox(width: 8),
                      ...viewModel.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.name),
                            selected: _selectedCategoryId == category.id,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategoryId =
                                    selected ? category.id : null;
                              });
                              if (selected) {
                                viewModel.filterByCategory(category.id);
                              } else {
                                viewModel.clearFilter();
                              }
                            },
                            backgroundColor: Colors.grey[200],
                            selectedColor: Color(
                              int.parse(category.color.replaceAll('#', '0xFF')),
                            ).withOpacity(0.2),
                            checkmarkColor: Color(
                              int.parse(category.color.replaceAll('#', '0xFF')),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Products count
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total Products: ${viewModel.products.length}',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedCategoryId != null)
                        Text(
                          'Category: ${viewModel.categories.firstWhere((c) => c.id == _selectedCategoryId).name}',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products list
          Expanded(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.products.isEmpty
                    ? _buildEmptyState()
                    : filteredProducts.isEmpty
                    ? _buildNoResultsState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(
                          context,
                          filteredProducts[index],
                        );
                      },
                    ),
          ),
        ],
      ),
      // Đã loại bỏ floatingActionButton
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image (giữ nguyên)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child:
                    product.image.isNotEmpty
                        ? Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ),
              ),
            ),
            const SizedBox(width: 16),

            // Product details (giữ nguyên)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Giữ nguyên nội dung hiện tại
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Các thông tin khác...
                ],
              ),
            ),

            // Action buttons (thêm nút chỉnh sửa nhanh)
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showQuickEditDialog(context, product);
                  },
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, product.id, product.name);
                  },
                  tooltip: 'Delete Product',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Thêm phương thức mới để hiển thị hộp thoại chỉnh sửa nhanh
  Future<void> _showQuickEditDialog(
    BuildContext context,
    Product product,
  ) async {
    final nameController = TextEditingController(text: product.name);
    final descriptionController = TextEditingController(
      text: product.description,
    );
    final richDescriptionController = TextEditingController(
      text: product.richDescription,
    );
    final brandController = TextEditingController(text: product.brand);
    final priceController = TextEditingController(
      text: product.price.toString(),
    );
    final countInStockController = TextEditingController(
      text: product.countInStock.toString(),
    );
    final ratingController = TextEditingController(
      text: product.rating.toString(),
    );
    final numReviewsController = TextEditingController(
      text: product.numReviews.toString(),
    );

    String? selectedCategoryId = product.category.id;
    bool isFeatured = product.isFeatured;

    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    final categories = viewModel.categories;

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit ${product.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Trường tên
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trường mô tả
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trường mô tả phong phú
                    TextField(
                      controller: richDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Rich Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Trường thương hiệu
                    TextField(
                      controller: brandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trường giá
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Danh mục
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategoryId,
                      items:
                          categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Trường số lượng trong kho
                    TextField(
                      controller: countInStockController,
                      decoration: const InputDecoration(
                        labelText: 'Count In Stock',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Trường đánh giá
                    TextField(
                      controller: ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Trường số lượng đánh giá
                    TextField(
                      controller: numReviewsController,
                      decoration: const InputDecoration(
                        labelText: 'Number of Reviews',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Trường nổi bật
                    SwitchListTile(
                      title: const Text('Featured Product'),
                      value: isFeatured,
                      onChanged: (value) {
                        setState(() {
                          isFeatured = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Tạo dữ liệu sản phẩm từ form
                    final productData = {
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'richDescription': richDescriptionController.text,
                      'brand': brandController.text,
                      'price':
                          double.tryParse(priceController.text) ??
                          product.price,
                      'category': selectedCategoryId,
                      'countInStock':
                          int.tryParse(countInStockController.text) ??
                          product.countInStock,
                      'rating':
                          double.tryParse(ratingController.text) ??
                          product.rating,
                      'numReviews':
                          int.tryParse(numReviewsController.text) ??
                          product.numReviews,
                      'isFeatured': isFeatured,
                    };

                    Navigator.pop(dialogContext);

                    // Hiển thị loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    try {
                      // Cập nhật sản phẩm
                      final success = await viewModel.updateProduct(
                        product.id,
                        productData,
                      );

                      // Đóng loading indicator
                      Navigator.of(context).pop();

                      // Hiển thị thông báo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Product updated successfully'
                                : 'Failed to update product: ${viewModel.errorMessage}',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    } catch (e) {
                      // Đóng loading indicator
                      Navigator.of(context).pop();

                      // Hiển thị thông báo lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a product to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductView()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No matching products',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or category',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedCategoryId = null;
              });
              Provider.of<ProductViewModel>(
                context,
                listen: false,
              ).clearFilter();
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
