import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:why_bandung/models/lib/resto_entry.dart';
import 'dart:convert';

class ProductForm extends StatefulWidget {
  final List<Toko> tokoList; // Add tokoList parameter

  // Accept tokoList as a parameter in the constructor
  ProductForm({required this.tokoList});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String? _selectedToko;

  // Fungsi untuk menambahkan produk
  Future<void> addProduct() async {
    final String name = _nameController.text;
    final String price = _priceController.text;
    final String description = _descriptionController.text;
    final String image = _imageController.text;
    final String tokoId = _selectedToko!;

    final response = await http.post(
      Uri.parse('http://localhost:8000/admin/create-product-flutter/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'price': int.parse(price),
        'description': description,
        'image': image,
        'toko': tokoId,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah produk ditambahkan
    } else {
      throw Exception('Failed to add product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Product Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              // Dropdown Button to Select Toko
              DropdownButtonFormField<String>(
                value: _selectedToko,
                decoration: InputDecoration(labelText: 'Select Restaurant'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedToko = newValue;
                  });
                },
                items: widget.tokoList.map<DropdownMenuItem<String>>((Toko toko) {
                  return DropdownMenuItem<String>(
                    value: toko.id,
                    child: Text(toko.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a restaurant';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addProduct();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
