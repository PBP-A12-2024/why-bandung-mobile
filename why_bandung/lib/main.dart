import 'package:flutter/material.dart';
import 'package:why_bandung/dashboard/screens/home.dart';
import 'package:why_bandung/dashboard/screens/profile.dart';
import 'package:why_bandung/product_page/screens/product_page.dart';
import 'package:why_bandung/dashboard_admin/screens/dashboard_admin.dart';
import 'components/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainApp(isAdmin: true), // Toggle isAdmin to true or false
    );
  }
}

class MainApp extends StatefulWidget {
  final bool isAdmin;

  const MainApp({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _userPages = [
    MainPage(),
    // SearchPage(),
    ProfilePage(),
  ];

  final List<Widget> _adminPages = [
    MainPage(),
    // SearchPage(),
    // AdminPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Show notification when already on the selected page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are already on ${_getCurrentPageName(index)}'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // Navigate to the selected page
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  String _getCurrentPageName(int index) {
    if (widget.isAdmin) {
      return ['Home','Search', 'Admin', 'Profile'][index];
    } else {
      return ['Home', 'Search', 'Profile'][index];
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.isAdmin ? _adminPages : _userPages;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        isAdmin: widget.isAdmin,
        onTap: _onItemTapped,
      ),
    );
  }
}

