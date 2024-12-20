import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:why_bandung/dashboard_admin/screens/edit_resto.dart';
import 'package:why_bandung/dashboard_admin/screens/product_page.dart';

class FoodCard extends StatelessWidget {
  final String title;
  final String location;
  final String restaurantId;
  final VoidCallback onDelete; // Callback untuk penghapusan di Flutter
  final VoidCallback onEdit; // Callback untuk edit di Flutter

  FoodCard({
    required this.title,
    required this.location,
    required this.restaurantId,
    required this.onDelete,
    required this.onEdit, // Tambahkan onEdit sebagai parameter wajib
  });

  Future<void> deleteResto(BuildContext context) async {
    final url = Uri.parse('http://localhost:8000/admin/delete-toko-flutter/$restaurantId/');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restoran berhasil dihapus')),
        );
        onDelete(); // Panggil callback untuk menghapus item dari daftar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus restoran: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F9EA0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Navigasikan ke ProductPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            restaurantId: restaurantId,
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
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey, size: 25),
                  onPressed: onEdit, // Panggil callback onEdit
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey, size: 25),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.white, // Latar belakang putih
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Sudut melengkung
                        ),
                        title: const Text(
                          'Konfirmasi',
                          style: TextStyle(color: Colors.black), // Teks hitam
                        ),
                        content: const Text(
                          'Apakah Anda yakin ingin menghapus restoran ini?',
                          style: TextStyle(color: Colors.black), // Teks hitam
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(Colors.black), // Warna teks hitam
                              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                (states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.grey.shade300; // Efek hover abu muda
                                  }
                                  return null;
                                },
                              ),
                            ),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              deleteResto(context); // Panggil fungsi delete
                            },
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(Colors.black), // Warna teks hitam
                              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                (states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Colors.grey.shade300; // Efek hover abu muda
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
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
