import 'package:flutter/material.dart';
import 'package:why_bandung/models/lib/produk_entry.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus {
  Like,
  Dislike,
}

class CardProvider extends ChangeNotifier {
  List<Produk> foodList = [];
  bool isDragging = false;
  Offset position = Offset.zero;
  double angle = 0;
  Size screenSize = Size.zero;

  CardProvider() {
    resetCards();
  }

  void resetCards() {
    foodList = [
      Produk(
          model: '',
          pk: '1',
          fields: Fields(
              name: 'PISANG GORENG',
              price: 15000,
              description:
                  'Pisang goreng crispy dengan topping keju dan coklat',
              image:
                  'https://plus.unsplash.com/premium_photo-1731950841187-cfbec0ed025b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8',
              toko: 'Warung Pisgor Mantap')),
      Produk(
          model: '',
          pk: '2',
          fields: Fields(
              name: 'SURABI ONCOM',
              price: 12000,
              description:
                  'Surabi tradisional dengan topping oncom khas Bandung',
              image:
                  'https://plus.unsplash.com/premium_photo-1731950841187-cfbec0ed025b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8',
              toko: 'Surabi Enhaii')),
      Produk(
          model: '',
          pk: '3',
          fields: Fields(
              name: 'BATAGOR',
              price: 20000,
              description: 'Batagor dengan bumbu kacang special',
              image:
                  'https://plus.unsplash.com/premium_photo-1731950841187-cfbec0ed025b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8',
              toko: 'Batagor Riri')),
      Produk(
          model: '',
          pk: '4',
          fields: Fields(
              name: 'SEBLAK',
              price: 18000,
              description: 'Seblak pedas level 1-5 dengan berbagai topping',
              image:
                  'https://images.unsplash.com/photo-1733395445556-de9323e37a00?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyNnx8fGVufDB8fHx8fA%3D%3D',
              toko: 'Seblak Jeletot')),
      Produk(
          model: '',
          pk: '5',
          fields: Fields(
              name: 'CIRENG',
              price: 10000,
              description: 'Cireng bumbu rujak pedas manis',
              image:
                  'https://plus.unsplash.com/premium_photo-1731950841187-cfbec0ed025b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw2fHx8ZW58MHx8fHx8',
              toko: 'Cireng Bang Ipul')),
    ];
    notifyListeners();
  }

  void setScreenSize(Size size) {
    screenSize = size;
  }

  void startPosition(DragStartDetails details) {
    isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    position += details.delta;
    final x = position.dx;
    angle = 0.1 * x;

    notifyListeners();
  }

  CardStatus? getCardStatus() {
    final x = position.dx;
    final delta = 100;

    if (x >= delta) {
      return CardStatus.Like;
    } else if (x <= -delta) {
      return CardStatus.Dislike;
    }
    return null;
  }

  Future nextCard() async {
    if (foodList.isEmpty) {
      print("masuk ke string kosong");
      resetCards();
      return;
    }

    foodList.removeLast();
    notifyListeners();
  }

  void likeCard() async {
    if (position == Offset.zero) {
      position += Offset(0.8, 0);
    }
    position += Offset(screenSize.width, screenSize.height * 0.5);
    angle = 45;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 1200));
    await nextCard();

    position = Offset.zero;
    angle = 0;
    notifyListeners();
  }

  void dislikeCard() async {
    if (position == Offset.zero) {
      position += Offset(-0.8, 0);
    }
    position += Offset(-screenSize.width, screenSize.height * 0.5);
    angle = -45;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 1200));
    await nextCard();

    position = Offset.zero;
    angle = 0;
    notifyListeners();
  }

  void endPosition() {
    isDragging = false;
    final status = getCardStatus();

    if (status != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        switch (status) {
          case CardStatus.Like:
            likeCard();
            break;
          case CardStatus.Dislike:
            dislikeCard();
            break;
        }
      });
    } else {
      position = Offset.zero;
      angle = 0;
      notifyListeners();
    }
  }
}
