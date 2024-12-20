import 'package:flutter/material.dart';
import 'package:why_bandung/models/lib/produk_entry.dart';
import 'package:why_bandung/food_finder/screens/foodCard.dart';
import 'package:provider/provider.dart';
import 'package:why_bandung/provider/cardProvider.dart';

class MainFinder extends StatefulWidget {
  const MainFinder({super.key});

  @override
  State<MainFinder> createState() => _MainFinderState();
}

class _MainFinderState extends State<MainFinder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildHeader(),
                    SizedBox(height: 16),
                    Expanded(child: buildFoodCard()),
                    SizedBox(height: 16),
                    buildButton(),
                  ],
                ))),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Image.asset(
          'assets/image/logo.png',
          height: 70,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Text('WhyBandung',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget buildButton() {
    final provider = Provider.of<CardProvider>(context);
    return Container(
      constraints: BoxConstraints(maxWidth: 280),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
              ),
              onPressed: () => provider.dislikeCard(),
              child: Icon(
                Icons.clear,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
              ),
              onPressed: () => provider.likeCard(),
              child: Icon(
                Icons.favorite,
                color: Colors.teal,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFoodCard() {
    final provider = Provider.of<CardProvider>(context);
    final foodList = provider.foodList;

    return Stack(
      children: List.generate(foodList.length, (index) {
        final food = foodList[index];
        return FoodCard(
          food: food,
          isFront: index == foodList.length - 1,
        );
      }).toList(),
    );
  }
}
