import 'package:flutter/material.dart';
import 'package:why_bandung/dashboard/screens/home.dart';
import 'package:why_bandung/product_page/screens/product_page.dart';
import 'package:why_bandung/dashboard/screens/profile.dart';
import 'package:why_bandung/dashboard_admin/screens/dashboard_admin.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isAdmin;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.isAdmin,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(isAdmin ? Icons.admin_panel_settings : Icons.search),
          label: isAdmin ? 'Admin' : 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
    );
  }
}
