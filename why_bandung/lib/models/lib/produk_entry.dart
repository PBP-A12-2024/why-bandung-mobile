import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Produk> produk;

  Welcome({
    required this.produk,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        produk: List<Produk>.from(json["produk"].map((x) => Produk.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "produk": List<dynamic>.from(produk.map((x) => x.toJson())),
      };
}

class Produk {
  String id;
  String name;
  int price;
  String description;
  String image;
  String tokoId;
  String tokoName;

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.tokoId,
    required this.tokoName,
  });

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
        tokoId: json["toko_id"],
        tokoName: json["toko_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "image": image,
        "toko_id": tokoId,
        "toko_name": tokoName,
      };
}
