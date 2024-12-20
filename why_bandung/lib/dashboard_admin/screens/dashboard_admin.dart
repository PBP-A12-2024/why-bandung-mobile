import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:why_bandung/models/lib/resto_entry.dart'; // Update with the correct path for your models
import 'package:why_bandung/dashboard_admin/screens/produkentry_form.dart';
import 'package:why_bandung/dashboard_admin/screens/restoentry_form.dart'; // Update with correct path to ProductForm
import 'package:why_bandung/dashboard_admin/screens/edit_resto.dart'; // Update with correct path to EditRestoPage
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
        scaffoldBackgroundColor: Colors.grey[200], // Latar belakang abu-abu muda
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
  bool isFilterActive = false;
  String? selectedLocation;
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    tokoList = fetchTokoData();
    fetchLocations();
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

  Future<void> fetchLocations() async {
    try {
      final List<Toko> tokoData = await tokoList;
      setState(() {
        locations = tokoData.map((t) => t.location).toSet().toList();
      });
    } catch (e) {
      // Handle error if necessary
    }
  }

  void refreshTokoList() {
    setState(() {
      tokoList = fetchTokoData();
      fetchLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Why Bandung?'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
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
                      height: 35, // Ukuran tombol lebih kecil
                      child: ItemCard(
                        item,
                        onAddRestaurant: (name, location) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestoEntryFormPage(
                                onSubmit: (name, location) {
                                  refreshTokoList(); // Refresh the list when a new restaurant is added
                                },
                              ),
                            ),
                          ).then((_) => refreshTokoList()); // Refresh after returning
                        },
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
          // Tambahkan tombol filter by location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align items in the center horizontally
              mainAxisAlignment: MainAxisAlignment.center,  // Align items in the center vertically
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the switch and text
                  children: [
                    Switch(
                      value: isFilterActive,
                      onChanged: (value) {
                        setState(() {
                          isFilterActive = value;
                          if (!isFilterActive) selectedLocation = null;
                        });
                      },
                      // activeThumbColor: Colors.white,
                      activeTrackColor: Colors.teal, // Change color of the switch to teal
                      inactiveThumbColor: Colors.grey, // Warna thumb saat tidak aktif
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                    const Text('Filter by Location'),
                  ],
                ),
                if (isFilterActive)
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Select Location'),
                    value: selectedLocation,
                    dropdownColor: Colors.white,
                    items: locations
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),
                if (isFilterActive && selectedLocation != null)
                  Center( // Ensure the button is centered
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedLocation = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child: const Text(
                        'Clear Location Filter Selection',
                        style: TextStyle(color: Colors.white), // Text color is white
                      ),
                    ),
                  ),
              ],
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

                // Data yang sudah selesai di-fetch
                List<Toko> tokoListData = snapshot.data!;

                if (isFilterActive && selectedLocation != null) {
                  tokoListData = tokoListData
                      .where((toko) => toko.location == selectedLocation)
                      .toList();
                }

                return ListView.builder(
                  itemCount: tokoListData.length,
                  itemBuilder: (context, index) {
                    final toko = tokoListData[index];
                    return FoodCard(
                      title: toko.name,
                      location: toko.location,
                      restaurantId: toko.id,
                      onDelete: () {
                        setState(() {
                          tokoListData.removeWhere((t) => t.id == toko.id); // Hapus dari daftar lokal
                        });
                      },
                      onEdit: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRestoPage(
                              restaurantId: toko.id,
                              initialName: toko.name,
                              initialLocation: toko.location,
                            ),
                          ),
                        );
                        if (result == true) {
                          refreshTokoList(); // Refresh data setelah edit berhasil
                        }
                      },
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
            ).then((_) {
              if (onAddRestaurant != null) {
                onAddRestaurant!("", "");
              }
            });
          } else if (item.name == "Add Product") {
            if (onAddProduct != null) {
              onAddProduct!();
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0), // Padding lebih kecil
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 14, color: Colors.white), // Perkecil ukuran ikon
              const SizedBox(width: 4),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 12, // Perkecil ukuran font
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
