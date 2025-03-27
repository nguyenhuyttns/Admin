// widgets/admin_drawer.dart (update)

import 'package:flutter/material.dart';
import '../utils/auth_utils.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[900]!],
          ),
        ),
        child: Column(
          children: [
            // Admin Header with profile
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<String?>(
                    future: AuthUtils.getToken(),
                    builder: (context, snapshot) {
                      return Text(
                        'Administrator',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              color: Colors.white.withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),

            // Menu Items
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.dashboard_rounded,
                      title: 'Dashboard',
                      route: '/admin',
                      replace: true,
                      isFirst: true,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.people_alt_rounded,
                      title: 'User Management',
                      route: '/users',
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.category_rounded,
                      title: 'Category Management',
                      route: '/categories',
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.inventory_2_rounded,
                      title: 'Product Management',
                      route: '/products',
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.shopping_cart_rounded,
                      title: 'Order Management',
                      route: '/orders',
                    ),
                    const Divider(height: 1),

                    // Logout button at the bottom
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Show a confirmation dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('LOGOUT'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await AuthUtils.logout();
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('LOGOUT'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    bool replace = false,
    bool isFirst = false,
  }) {
    // Check if the current route matches this menu item
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return Container(
      margin: EdgeInsets.only(
        top: isFirst ? 8 : 0,
        bottom: 0,
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue[700] : Colors.grey[700],
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue[700] : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing:
            isSelected
                ? Container(
                  height: 30,
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
                : null,
        onTap: () {
          if (replace) {
            Navigator.pushReplacementNamed(context, route);
          } else {
            Navigator.pushNamed(context, route);
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
