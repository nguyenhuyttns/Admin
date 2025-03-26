// main.dart (update)

import 'package:admin/view_models/category_view_model.dart';
import 'package:admin/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'view_models/login_view_model.dart';
import 'views/admin_dashboard.dart';
import 'views/user_management_view.dart';
import 'views/add_user_view.dart';
import 'views/category_management_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/admin': (context) => const AdminDashboard(),
        '/users': (context) => const UserManagementView(),
        '/add-user': (context) => const AddUserView(),
        '/categories': (context) => const CategoryManagementView(),
      },
    );
  }
}
