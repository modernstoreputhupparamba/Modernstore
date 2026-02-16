// To parse this JSON data, do
//
//     final loginmodel = loginmodelFromJson(jsonString);

import 'dart:convert';

Loginmodel loginmodelFromJson(String str) => Loginmodel.fromJson(json.decode(str));

String loginmodelToJson(Loginmodel data) => json.encode(data.toJson());


class Loginmodel {
    bool? success;
    User? user;
    String? accessToken;

    Loginmodel({this.success, this.user, this.accessToken});

    Loginmodel.fromJson(Map<String, dynamic> json) {
        success = json["success"];
        user = json["user"] == null ? null : User.fromJson(json["user"]);
        accessToken = json["accessToken"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        if(user != null) {
            _data["user"] = user?.toJson();
        }
        _data["accessToken"] = accessToken;
        return _data;
    }
}

class User {
    String? id;
    dynamic name;
    String? phoneNumber;
    dynamic email;
    dynamic profileImage;
    String? role;
    List<String>? userDlvAddresses;
    String? createdAt;
    String? updatedAt;
    int? v;

    User({this.id, this.name, this.phoneNumber, this.email, this.profileImage, this.role, this.userDlvAddresses, this.createdAt, this.updatedAt, this.v});

    User.fromJson(Map<String, dynamic> json) {
        id = json["_id"];
        name = json["name"];
        phoneNumber = json["phoneNumber"];
        email = json["email"];
        profileImage = json["profileImage"];
        role = json["role"];
        userDlvAddresses = json["userDlvAddresses"] == null ? null : List<String>.from(json["userDlvAddresses"]);
        createdAt = json["createdAt"];
        updatedAt = json["updatedAt"];
        v = json["__v"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        _data["phoneNumber"] = phoneNumber;
        _data["email"] = email;
        _data["profileImage"] = profileImage;
        _data["role"] = role;
        if(userDlvAddresses != null) {
            _data["userDlvAddresses"] = userDlvAddresses;
        }
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        return _data;
    }
}