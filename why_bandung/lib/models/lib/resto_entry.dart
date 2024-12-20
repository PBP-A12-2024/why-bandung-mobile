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
    String id;
    String name;
    String location;

    Toko({
        required this.id,
        required this.name,
        required this.location,
    });

    factory Toko.fromJson(Map<String, dynamic> json) => Toko(
        id: json["id"],
        name: json["name"],
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
    };
}
