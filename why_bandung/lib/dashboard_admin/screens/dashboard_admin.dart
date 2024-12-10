import 'package:flutter/material.dart';
import 'package:why_bandung/dashboard_admin/screens/restoentry_form.dart';
import 'package:why_bandung/models/lib/resto_entry.dart';
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

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
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

  Welcome welcomeData = Welcome(toko: []); // Untuk menyimpan data toko

  void addRestaurant(Fields fields) {
    setState(() {
      // Membuat Toko baru
      Toko newToko = Toko(
        model: "restaurant.restaurant",
        pk: DateTime.now().toString(), // Temporary pk
        fields: fields,
      );
      welcomeData.toko.add(newToko);
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
      body: Column(
        children: [
          // Buttons Row
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
                        onAddRestaurant: addRestaurant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Restaurant List
          Expanded(
            child: ListView.builder(
              itemCount: welcomeData.toko.length,
              itemBuilder: (context, index) {
                final toko = welcomeData.toko[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(toko.fields.name),
                    subtitle: Text(toko.fields.location),
                  ),
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
  final Function(Fields)? onAddRestaurant;

  const ItemCard(this.item, {super.key, this.onAddRestaurant});

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