import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:why_bandung/models/lib/produk_entry.dart';  // Your model for ProductEntry
import 'package:cached_network_image/cached_network_image.dart';
import 'package:why_bandung/dashboard_admin/screens/edit_produk.dart';

class ProductPage extends StatefulWidget {
  final String restaurantId;  // Store the restaurant ID
  final String restaurantName;

  ProductPage({required this.restaurantId, required this.restaurantName});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Produk>> _productsFuture;
  List<Produk> _products = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProductsForToko(widget.restaurantId);
  }

  // Function to fetch products based on restaurant ID
  Future<List<Produk>> fetchProductsForToko(String tokoId) async {
    print('Fetching products for toko_id: $tokoId');
    final response = await http.get(Uri.parse('http://localhost:8000/admin/get-products-by-toko/$tokoId/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Produk>.from(data.map((item) => Produk.fromJson(item)));
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }

  // Function to delete a product by ID
  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/admin/delete-product-flutter/$productId/'),
      );

      if (response.statusCode == 200) {
        // If delete is successful, update local state
        setState(() {
          _products.removeWhere((product) => product.id == productId);
        });
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      appBar: AppBar(
        title: Text('Produk di ${widget.restaurantName}'),
        backgroundColor: Colors.grey[200],
      ),
      body: FutureBuilder<List<Produk>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          // Update the local product list with fetched data
          _products = snapshot.data!;

          return ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Card(
                color: Colors.white, // White card color
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.image, size: 80),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp ${product.price}',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductPage(product: product),
                                ),
                              );

                              if (result == true) {
                                // Refresh the product list after editing
                                setState(() {
                                  _productsFuture = fetchProductsForToko(widget.restaurantId);
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () async {
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white, // Background putih
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Sudut melengkung
                                  ),
                                  title: const Text(
                                    'Konfirmasi',
                                    style: TextStyle(color: Colors.black), // Teks hitam
                                  ),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus produk ini?',
                                    style: TextStyle(color: Colors.black), // Teks hitam
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all(Colors.black), // Warna teks hitam
                                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                          (states) {
                                            if (states.contains(WidgetState.hovered)) {
                                              return Colors.grey.shade300; // Hover abu-abu muda
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all(Colors.black), // Warna teks hitam
                                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                          (states) {
                                            if (states.contains(WidgetState.hovered)) {
                                              return Colors.grey.shade300; // Hover abu-abu muda
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await deleteProduct(product.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
