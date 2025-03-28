// views/order_management/dialogs/update_status_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order.dart';
import '../../../view_models/order_view_model.dart';
import '../utils/order_utils.dart';

class UpdateStatusDialog extends StatefulWidget {
  final Order order;

  const UpdateStatusDialog({super.key, required this.order});

  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  late String selectedStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context);
    final statusOptions = [
      'Pending',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled',
    ];

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.edit, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Update Order Status'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current status
          const Text(
            'Current Status:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: OrderUtils.getStatusColor(
                widget.order.status,
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: OrderUtils.getStatusColor(widget.order.status),
              ),
            ),
            child: Text(
              widget.order.status,
              style: TextStyle(
                color: OrderUtils.getStatusColor(widget.order.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // New status selection
          const Text(
            'New Status:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Status radio buttons
          Column(
            children:
                statusOptions.map((status) {
                  return RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: selectedStatus,
                    activeColor: OrderUtils.getStatusColor(status),
                    onChanged:
                        _isUpdating
                            ? null
                            : (String? value) {
                              setState(() {
                                selectedStatus = value!;
                              });
                            },
                  );
                }).toList(),
          ),

          // Error message
          if (viewModel.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                viewModel.errorMessage,
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed:
              _isUpdating
                  ? null
                  : () {
                    Navigator.of(context).pop();
                  },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _isUpdating
                  ? null
                  : () async {
                    // Nếu trạng thái không thay đổi, đóng dialog
                    if (selectedStatus == widget.order.status) {
                      Navigator.of(context).pop();
                      return;
                    }

                    setState(() {
                      _isUpdating = true;
                    });

                    // Cập nhật trạng thái đơn hàng
                    final success = await viewModel.updateOrderStatus(
                      widget.order.id,
                      selectedStatus,
                    );

                    if (success) {
                      Navigator.of(context).pop();

                      // Hiển thị thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Order status updated to $selectedStatus',
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      setState(() {
                        _isUpdating = false;
                      });
                      // Không đóng dialog để người dùng có thể thử lại
                    }
                  },
          child:
              _isUpdating
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text('Update'),
        ),
      ],
    );
  }
}
