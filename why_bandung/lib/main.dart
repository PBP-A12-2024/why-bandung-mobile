import 'package:flutter/material.dart';
import 'package:why_bandung/dashboard/screens/home.dart';
<<<<<<< HEAD
import 'package:why_bandung/dashboard/screens/profile.dart';
import 'package:why_bandung/product_page/screens/product_page.dart';
import 'package:why_bandung/dashboard_admin/screens/dashboard_admin.dart';
import 'components/bottom_nav_bar.dart';
=======
import 'package:why_bandung/dashboard_admin/screens/dashboard_admin.dart';
>>>>>>> dashboard_admin

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      home: const MainApp(isAdmin: true), // Toggle isAdmin to true or false
=======
      title: 'WhyBandung?',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: AdminPage(),
>>>>>>> dashboard_admin
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

