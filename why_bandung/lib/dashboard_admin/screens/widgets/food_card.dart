import 'package:flutter/material.dart';
import 'package:why_bandung/dashboard_admin/screens/product_page.dart';

class FoodCard extends StatelessWidget {
  final String title;
  final String location;
  final String restaurantId; // Add restaurantId

  // Modify the constructor to accept restaurantId
  FoodCard({required this.title, required this.location, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(location),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft, // Align the button to the left
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F9EA0),  // Set the button color to match Add Product button
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),  // Increased padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                  ),
                ),
                onPressed: () {
                  // Use the passed restaurantId to navigate to the ProductPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(
                        restaurantId: restaurantId,  // Now it uses the passed restaurantId
                        restaurantName: title,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Produk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
