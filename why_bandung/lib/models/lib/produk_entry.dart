// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

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
    String model;
    String pk;
    Fields fields;

    Produk({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Produk.fromJson(Map<String, dynamic> json) => Produk(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    int price;
    String description;
    String image;
    String toko;

    Fields({
        required this.name,
        required this.price,
        required this.description,
        required this.image,
        required this.toko,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
        toko: json["toko"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "description": description,
        "image": image,
        "toko": toko,
    };
}
