// views/edit_product_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/product_view_model.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../config/api_config.dart';

class EditProductView extends StatefulWidget {
  final Product product;

  const EditProductView({super.key, required this.product});

  @override
  _EditProductViewState createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _richDescriptionController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _countInStockController;
  late TextEditingController _ratingController;
  late TextEditingController _numReviewsController;

  String? _selectedCategoryId;
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing product data
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _richDescriptionController = TextEditingController(
      text: widget.product.richDescription,
    );
    _brandController = TextEditingController(text: widget.product.brand);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _countInStockController = TextEditingController(
      text: widget.product.countInStock.toString(),
    );
    _ratingController = TextEditingController(
      text: widget.product.rating.toString(),
    );
    _numReviewsController = TextEditingController(
      text: widget.product.numReviews.toString(),
    );

    _selectedCategoryId = widget.product.category.id;
    _isFeatured = widget.product.isFeatured;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _richDescriptionController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _countInStockController.dispose();
    _ratingController.dispose();
    _numReviewsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);
    final categories = viewModel.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product ID
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Product ID: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.product.id,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Basic Information Section
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Product Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'Enter product name',
                          prefixIcon: const Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter product description',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rich Description
                      TextFormField(
                        controller: _richDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Rich Description',
                          hintText: 'Enter rich description (optional)',
                          prefixIcon: const Icon(Icons.text_fields),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Brand
                      TextFormField(
                        controller: _brandController,
                        decoration: InputDecoration(
                          labelText: 'Brand',
                          hintText: 'Enter product brand',
                          prefixIcon: const Icon(Icons.branding_watermark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price and Stock Section
                      const Text(
                        'Pricing & Inventory',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'Enter product price',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Count in Stock
                      TextFormField(
                        controller: _countInStockController,
                        decoration: InputDecoration(
                          labelText: 'Count in Stock',
                          hintText: 'Enter available stock',
                          prefixIcon: const Icon(Icons.inventory),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter stock quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: const Text('Select a category'),
                        value: _selectedCategoryId,
                        items:
                            categories.map((Category category) {
                              return DropdownMenuItem<String>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rating & Reviews Section
                      const Text(
                        'Rating & Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rating
                      TextFormField(
                        controller: _ratingController,
                        decoration: InputDecoration(
                          labelText: 'Rating',
                          hintText: 'Enter product rating (0-5)',
                          prefixIcon: const Icon(Icons.star),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a rating';
                          }
                          final rating = double.tryParse(value);
                          if (rating == null) {
                            return 'Please enter a valid number';
                          }
                          if (rating < 0 || rating > 5) {
                            return 'Rating must be between 0 and 5';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Number of Reviews
                      TextFormField(
                        controller: _numReviewsController,
                        decoration: InputDecoration(
                          labelText: 'Number of Reviews',
                          hintText: 'Enter number of reviews',
                          prefixIcon: const Icon(Icons.rate_review),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter number of reviews';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Featured Switch
                      SwitchListTile(
                        title: const Text('Featured Product'),
                        subtitle: const Text(
                          'Show this product on the featured section',
                        ),
                        value: _isFeatured,
                        onChanged: (value) {
                          setState(() {
                            _isFeatured = value;
                          });
                        },
                        secondary: const Icon(Icons.featured_play_list),
                      ),
                      const SizedBox(height: 16),

                      // Product Image Section
                      const Text(
                        'Product Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Current image display
                      if (widget.product.image.isNotEmpty)
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Unable to load image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Image info text
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Image will remain unchanged. To update the image, use the image upload feature separately.',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              final productData = {
                                'name': _nameController.text,
                                'description': _descriptionController.text,
                                'richDescription':
                                    _richDescriptionController.text,
                                'brand': _brandController.text,
                                'price':
                                    double.tryParse(_priceController.text) ??
                                    0.0,
                                'category': _selectedCategoryId,
                                'countInStock':
                                    int.tryParse(
                                      _countInStockController.text,
                                    ) ??
                                    0,
                                'rating':
                                    double.tryParse(_ratingController.text) ??
                                    0.0,
                                'numReviews':
                                    int.tryParse(_numReviewsController.text) ??
                                    0,
                                'isFeatured': _isFeatured,
                              };

                              // Store the scaffold messenger for later use
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );

                              try {
                                final success = await viewModel.updateProduct(
                                  widget.product.id,
                                  productData,
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                if (success) {
                                  Navigator.pop(context);
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Product updated successfully',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to update product: ${viewModel.errorMessage}',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'UPDATE PRODUCT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
