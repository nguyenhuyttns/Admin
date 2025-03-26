// views/user_management_view.dart (update)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/user_view_model.dart';
import '../utils/auth_guard.dart';
import 'add_user_view.dart';
import 'edit_user_view.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasAccess = await AuthGuard.checkAuth(context);
      if (hasAccess) {
        Provider.of<UserViewModel>(context, listen: false).getUsers();
      }
    });
  }

  // views/user_management_view.dart (update only the _showDeleteConfirmation method)

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    String userId,
    String userName,
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
                Text('Are you sure you want to delete user "$userName"?'),
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

                final viewModel = Provider.of<UserViewModel>(
                  context,
                  listen: false,
                );

                try {
                  final success = await viewModel.deleteUser(userId);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to delete user: ${viewModel.errorMessage}',
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.getUsers(),
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.users.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                itemCount: viewModel.users.length,
                itemBuilder: (context, index) {
                  final user = viewModel.users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${user.email}"),
                          Text("Phone: ${user.phone}"),
                          Text(
                            "Address: ${user.street}, ${user.apartment}, ${user.city}, ${user.country}",
                          ),
                          Row(
                            children: [
                              const Text("Role: "),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      user.isAdmin
                                          ? Colors.blue
                                          : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  user.isAdmin ? "Admin" : "User",
                                  style: TextStyle(
                                    color:
                                        user.isAdmin
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditUserView(user: user),
                                ),
                              );
                            },
                            tooltip: 'Edit User',
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmation(
                                context,
                                user.id,
                                user.name,
                              );
                            },
                            tooltip: 'Delete User',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserView()),
          );
        },
        tooltip: 'Add New User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
