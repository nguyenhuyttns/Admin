// views/order_management_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/order_view_model.dart';
import '../../utils/auth_guard.dart';
import 'widgets/order_card.dart';
import 'widgets/order_filters.dart';
import 'utils/order_utils.dart';

class OrderManagementView extends StatefulWidget {
  const OrderManagementView({super.key});

  @override
  _OrderManagementViewState createState() => _OrderManagementViewState();
}

class _OrderManagementViewState extends State<OrderManagementView> {
  String _searchQuery = '';
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasAccess = await AuthGuard.checkAuth(context);
      if (hasAccess) {
        Provider.of<OrderViewModel>(context, listen: false).getOrders();
      }
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _updateSelectedStatus(String? status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context);
    final filteredOrders = OrderUtils.filterOrders(
      viewModel.orders,
      _searchQuery,
      _selectedStatus,
    );

    // Get unique statuses from orders
    final statuses = OrderUtils.getUniqueStatuses(viewModel.orders);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.getOrders(),
            tooltip: 'Refresh Orders',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          OrderFilters(
            searchQuery: _searchQuery,
            selectedStatus: _selectedStatus,
            statuses: statuses,
            onSearchChanged: _updateSearchQuery,
            onStatusChanged: _updateSelectedStatus,
            totalOrders: viewModel.orders.length,
            filteredOrdersCount: filteredOrders.length,
          ),

          // Order list
          Expanded(
            child:
                viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.orders.isEmpty
                    ? _buildEmptyState()
                    : filteredOrders.isEmpty
                    ? _buildNoResultsState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(order: filteredOrders[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here when customers make purchases',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
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
            'No matching orders',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _clearFilters,
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
