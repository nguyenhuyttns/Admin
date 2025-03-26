// views/admin_dashboard.dart
import 'package:admin/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      drawer: const AdminDrawer(),
      body: const Center(child: Text("Welcome to Admin Dashboard")),
    );
  }
}
