import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:why_bandung/models/lib/resto_entry.dart';  // Update with the correct path for your models
import 'package:why_bandung/dashboard_admin/screens/produkentry_form.dart';
import 'package:why_bandung/dashboard_admin/screens/restoentry_form.dart'; // Update with correct path to ProductForm
import 'package:why_bandung/dashboard_admin/screens/widgets/food_card.dart'; // Update with correct path to FoodCard

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          secondary: const Color.fromARGB(255, 210, 78, 107),
        ),
      ),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final List<ItemHomepage> items = [
    ItemHomepage("Add Restaurant", Icons.add),
    ItemHomepage("Add Product", Icons.add),
  ];

  late Future<List<Toko>> tokoList;

  @override
  void initState() {
    super.initState();
    tokoList = fetchTokoData(); // Fetch data when the page is initialized
  }

  // Fetch data from Django API for restaurants (toko)
  Future<List<Toko>> fetchTokoData() async {
    final response = await http.get(Uri.parse('http://localhost:8000/admin/all-toko/')); // Update with your Django API endpoint

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('toko') && data['toko'] is List) {
        List<dynamic> tokoListData = data['toko'];
        return tokoListData.map((json) => Toko.fromJson(json)).toList();
      } else {
        throw Exception('Invalid data for toko');
      }
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Why Bandung?'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Button Row to navigate to different forms
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: items.map((item) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 45,
                      child: ItemCard(
                        item,
                        onAddRestaurant: (name, location) {},
                        onAddProduct: () {
                          // If "Add Product" button is pressed, navigate to ProductForm
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FutureBuilder<List<Toko>>(
                                  future: tokoList,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: Text('No Restaurants Found'));
                                    }

                                    return ProductForm(tokoList: snapshot.data!); // Pass the fetched tokoList
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Restaurant List
          Expanded(
            child: FutureBuilder<List<Toko>>(
              future: tokoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Restaurants Found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final toko = snapshot.data![index];
                    return FoodCard(
                      title: toko.name,
                      location: toko.location,
                      restaurantId: toko.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final Function(String, String)? onAddRestaurant;
  final Function()? onAddProduct;

  const ItemCard(this.item, {super.key, this.onAddRestaurant, this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 230, 90, 120),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (item.name == "Add Restaurant") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestoEntryFormPage(
                  onSubmit: onAddRestaurant,
                ),
              ),
            );
          } else if (item.name == "Add Product") {
            // If "Add Product" is pressed, navigate to ProductForm
            if (onAddProduct != null) {
              onAddProduct!();
            }
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text("You pressed ${item.name}!")),
              );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 24, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}
