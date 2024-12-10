// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    List<Toko> toko;

    Welcome({
        required this.toko,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        toko: List<Toko>.from(json["toko"].map((x) => Toko.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "toko": List<dynamic>.from(toko.map((x) => x.toJson())),
    };
}

class Toko {
    String model;
    String pk;
    Fields fields;

    Toko({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Toko.fromJson(Map<String, dynamic> json) => Toko(
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
    String location;

    Fields({
        required this.name,
        required this.location,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "location": location,
    };
}
