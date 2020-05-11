// To parse this JSON data, do
//
//     final employerModel = employerModelFromJson(jsonString);

import 'dart:convert';

EmployerModel employerModelFromJson(String str) => EmployerModel.fromJson(json.decode(str));

String employerModelToJson(EmployerModel data) => json.encode(data.toJson());

class EmployerModel {
    String uid;
    String name;
    String rol;
    String email;
    String passwd;
    String progress;

    EmployerModel({
        this.uid,
        this.name,
        this.rol,
        this.email,
        this.passwd,
        this.progress,
    });

    factory EmployerModel.fromJson(Map<String, dynamic> json) => EmployerModel(
        uid: json["uid"],
        name: json["name"],
        rol: json["rol"],
        email: json["email"],
        passwd: json["passwd"],
        progress: json["progress"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "rol": rol,
        "email": email,
        "passwd": passwd,
        "progress": progress,
    };
}
