import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:why_bandung/models/lib/produk_entry.dart';
import 'package:why_bandung/provider/cardProvider.dart';

class FoodCard extends StatefulWidget {
  final Produk food;
  final bool isFront;

  FoodCard({super.key, required this.food, required this.isFront});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFront ? buildFrontCard(context) : buildCard(context);
  }

  Widget buildFrontCard(BuildContext context) {
    return Consumer<CardProvider>(
      builder: (context, provider, _) {
        final miliseconds = provider.isDragging ? 0 : 1200;
        final center = MediaQuery.of(context).size.center(Offset.zero);
        final angle = provider.angle * pi / 180;
        final transform = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..rotateZ(angle)
          ..translate(-center.dx, -center.dy)
          ..translate(provider.position.dx, provider.position.dy);

        final rightOpacity = provider.position.dx >= 0
            ? provider.position.dx / (MediaQuery.of(context).size.width / 2)
            : 0.0;
        final leftOpacity = provider.position.dx <= 0
            ? -provider.position.dx / (MediaQuery.of(context).size.width / 2)
            : 0.0;

        return GestureDetector(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: miliseconds),
                curve: Curves.easeOutBack,
                transform: transform,
                child: Stack(
                  alignment: Alignment.center, // Tengah card
                  children: [
                    buildCard(context),
                    // Overlay LIKE
                    Opacity(
                      opacity: rightOpacity.clamp(0.0, 1.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'LIKE',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Overlay NOPE
                    Opacity(
                      opacity: leftOpacity.clamp(0.0, 1.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NOPE',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onPanStart: (details) {
            provider.startPosition(details);
          },
          onPanUpdate: (details) {
            provider.updatePosition(details);
          },
          onPanEnd: (details) {
            provider.endPosition();
          },
        );
      },
    );
  }

  Widget buildCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: 350,
          maxHeight: 600,
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFFDF6E1), width: 15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kontainer Info (Nama dan Harga)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFFDF6E1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.food.fields.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Rp ${widget.food.fields.price}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Gambar Latar
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFDF6E1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                    maxHeight: 300,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.food.fields.image),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Nama Vendor
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFDF6E1), width: 7),
              ),
              child: Center(
                child: Text(
                  "${widget.food.fields.toko}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFDF6E1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
