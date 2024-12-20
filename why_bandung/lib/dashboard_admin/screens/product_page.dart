import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:why_bandung/models/lib/produk_entry.dart';  // Your model for ProductEntry
import 'package:cached_network_image/cached_network_image.dart';

class ProductPage extends StatelessWidget {
  final String restaurantId;  // Store the restaurant ID
  final String restaurantName;

  ProductPage({required this.restaurantId, required this.restaurantName});

  // Function to fetch products based on restaurant ID
  Future<List<Produk>> fetchProductsForToko(String tokoId) async {
    print('Fetching products for toko_id: $tokoId');
    final response = await http.get(Uri.parse('http://localhost:8000/admin/get-products-by-toko/$tokoId/'));

    if (response.statusCode == 200) {
      // If the response is successful, parse the data
      //print('Response body: ${response.body}');  // Debugging response body
      final data = jsonDecode(response.body);
      
      // Convert the data to a list of Product objects
      return List<Produk>.from(data.map((item) => Produk.fromJson(item)));
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk di $restaurantName'),
      ),
      body: FutureBuilder<List<Produk>>(
        future: fetchProductsForToko(restaurantId),  // Get products by restaurant ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          // If the data is successfully fetched, display it in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: product.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),  // Placeholder while loading
                        errorWidget: (context, url, error) => Icon(Icons.error),  // Error icon if image fails to load
                      )
                    : Icon(Icons.image, size: 60),  // Placeholder icon if no image
                title: Text(product.name),
                subtitle: Text('Rp ${product.price}\n${product.description}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle Edit functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle Delete functionality
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
