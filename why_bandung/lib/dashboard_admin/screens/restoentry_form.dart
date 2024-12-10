import 'package:flutter/material.dart';
import 'package:why_bandung/models/lib/resto_entry.dart';

class RestoEntryFormPage extends StatefulWidget {
 final Function(Fields)? onSubmit;
 const RestoEntryFormPage({super.key, this.onSubmit});

 @override
 State<RestoEntryFormPage> createState() => _RestoEntryFormPageState();
}

class _RestoEntryFormPageState extends State<RestoEntryFormPage> {
 final _formKey = GlobalKey<FormState>();
 String _name = "";
 String _location = "";
 @override
 Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
       title: const Text(
         'Add Restaurant',
         style: TextStyle(color: Colors.black),
       ),
       backgroundColor: Colors.white,
       centerTitle: true,
       elevation: 0,
     ),
     body: Form(
       key: _formKey,
       child: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextFormField(
                   decoration: InputDecoration(
                     hintText: "Nama Restoran",
                     labelText: "Nama Restoran",
                     hintStyle: TextStyle(color: Colors.black),
                     labelStyle: TextStyle(color: Colors.black),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                         width: 1.0,
                       ),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                         width: 2.0,
                       ),
                     ),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                       ),
                     ),
                   ),
                   onChanged: (String? value) {
                     setState(() {
                       _name = value!;
                     });
                   },
                   validator: (String? value) {
                     if (value == null || value.isEmpty) {
                       return "Nama tidak boleh kosong!";
                     }
                     return null;
                   },
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: TextFormField(
                   decoration: InputDecoration(
                     hintText: "Alamat Restoran",
                     labelText: "Alamat Restoran",
                     hintStyle: TextStyle(color: Colors.black),
                     labelStyle: TextStyle(color: Colors.black),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                         width: 1.0,
                       ),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                         width: 2.0,
                       ),
                     ),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8.0),
                       borderSide: BorderSide(
                         color: Colors.black,
                       ),
                     ),
                   ),
                   onChanged: (String? value) {
                     setState(() {
                       _location = value!;
                     });
                   },
                   validator: (String? value) {
                     if (value == null || value.isEmpty) {
                       return "Alamat tidak boleh kosong!";
                     }
                     return null;
                   },
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF5F9EA0),
                       padding: const EdgeInsets.symmetric(vertical: 15.0),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8.0),
                       ),
                     ),
                     onPressed: () {
                       if (_formKey.currentState!.validate()) {
                         // Buat Fields object
                         final fields = Fields(
                           name: _name,
                           location: _location,
                         );
                         
                         // Panggil callback
                         widget.onSubmit?.call(fields);
                         
                         showDialog(
                           context: context,
                           builder: (context) {
                             return AlertDialog(
                               title: const Text('Restaurant berhasil tersimpan'),
                               content: SingleChildScrollView(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text('Nama Restoran: $_name'),
                                     Text('Alamat Restoran: $_location'),
                                   ],
                                 ),
                               ),
                               actions: [
                                 TextButton(
                                   child: const Text('OK'),
                                   onPressed: () {
                                     Navigator.pop(context); // Tutup dialog
                                     Navigator.pop(context); // Kembali ke halaman utama
                                     _formKey.currentState!.reset();
                                   },
                                 ),
                               ],
                             );
                           },
                         );
                       }
                     },
                     child: const Text(
                       "Submit",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 16,
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
 }
}