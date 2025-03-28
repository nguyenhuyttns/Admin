// views/order_management/widgets/order_filters.dart

import 'package:flutter/material.dart';
import '../utils/order_utils.dart';

class OrderFilters extends StatefulWidget {
  final String searchQuery;
  final String? selectedStatus;
  final List<String> statuses;
  final Function(String) onSearchChanged;
  final Function(String?) onStatusChanged;
  final int totalOrders;
  final int filteredOrdersCount;

  const OrderFilters({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.statuses,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.totalOrders,
    required this.filteredOrdersCount,
  });

  @override
  State<OrderFilters> createState() => _OrderFiltersState();
}

class _OrderFiltersState extends State<OrderFilters> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(OrderFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update controller text if the search query changed and controller text doesn't match
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _searchController.text) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search orders...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              // Add a clear button when there's text
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                      : null,
            ),
            onChanged: widget.onSearchChanged,
          ),

          const SizedBox(height: 16),

          // Status filter chips
          if (widget.statuses.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All status chip
                  FilterChip(
                    label: const Text('All'),
                    selected: widget.selectedStatus == null,
                    onSelected: (selected) {
                      if (selected) {
                        widget.onStatusChanged(null);
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.blue[100],
                    checkmarkColor: Colors.blue[800],
                  ),
                  const SizedBox(width: 8),

                  // Status chips from available statuses
                  ...widget.statuses.map((status) {
                    final color = OrderUtils.getStatusColor(status);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          status.substring(0, 1).toUpperCase() +
                              status.substring(1),
                        ),
                        selected:
                            widget.selectedStatus?.toLowerCase() ==
                            status.toLowerCase(),
                        onSelected: (selected) {
                          widget.onStatusChanged(selected ? status : null);
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: color.withOpacity(0.2),
                        checkmarkColor: color,
                      ),
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Order count
          Text(
            'Showing ${widget.filteredOrdersCount} of ${widget.totalOrders} orders',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
