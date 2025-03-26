// views/user_management_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/user_view_model.dart';

import '../utils/auth_guard.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body:
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: viewModel.users.length,
                itemBuilder: (context, index) {
                  final user = viewModel.users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${user.email}"),
                        Text("Phone: ${user.phone}"),
                        Text(
                          "Address: ${user.street}, ${user.apartment}, ${user.city}, ${user.country}",
                        ),
                      ],
                    ),
                    trailing: Switch(
                      value: user.isAdmin,
                      onChanged: (value) async {
                        await viewModel.updateUserRole(user.id, value);
                        viewModel.getUsers();
                      },
                    ),
                  );
                },
              ),
    );
  }
}
