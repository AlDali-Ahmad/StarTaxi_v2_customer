// To parse this JSON data, do
//
//     final driversReadyModel = driversReadyModelFromJson(jsonString);

import 'dart:convert';

DriversReadyModel driversReadyModelFromJson(String str) => DriversReadyModel.fromJson(json.decode(str));

String driversReadyModelToJson(DriversReadyModel data) => json.encode(data.toJson());

class DriversReadyModel {
    final String? message;
    final List<DriversReady>? data;

    DriversReadyModel({
        this.message,
        this.data,
    });

    factory DriversReadyModel.fromJson(Map<String, dynamic> json) => DriversReadyModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<DriversReady>.from(json["data"]!.map((x) => DriversReady.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class DriversReady {
    final String? id;
    final String? name;
    final String? gender;
    final String? avatar;
    final dynamic age;

    DriversReady({
        this.id,
        this.name,
        this.gender,
        this.avatar,
        this.age,
    });

    factory DriversReady.fromJson(Map<String, dynamic> json) => DriversReady(
        id: json["id"],
        name: json["name"],
        gender: json["gender"],
        avatar: json["avatar"],
        age: json["age"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "avatar": avatar,
        "age": age,
    };
}
