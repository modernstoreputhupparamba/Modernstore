
class GetUserDlvAddresses {
    bool? success;
    String? message;
    List<Data>? data;

    GetUserDlvAddresses({this.success, this.message, this.data});

    GetUserDlvAddresses.fromJson(Map<String, dynamic> json) {
        success = json["success"];
        message = json["message"];
        data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        _data["message"] = message;
        if(data != null) {
            _data["data"] = data?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Data {
    String? id;
    UserId? userId;
    String? address;
    String? city;
    String? pincode;
    String? latitude;
    String? longitude;
    String? createdAt;
    String? updatedAt;
    int? v;

    Data({this.id, this.userId, this.address, this.city, this.pincode, this.latitude, this.longitude, this.createdAt, this.updatedAt, this.v});

    Data.fromJson(Map<String, dynamic> json) {
        id = json["_id"];
        userId = json["userId"] == null ? null : UserId.fromJson(json["userId"]);
        address = json["address"];
        city = json["city"];
        pincode = json["pincode"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        createdAt = json["createdAt"];
        updatedAt = json["updatedAt"];
        v = json["__v"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        if(userId != null) {
            _data["userId"] = userId?.toJson();
        }
        _data["address"] = address;
        _data["city"] = city;
        _data["pincode"] = pincode;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        return _data;
    }
}

class UserId {
    String? id;
    dynamic name;
    String? phoneNumber;
    dynamic email;

    UserId({this.id, this.name, this.phoneNumber, this.email});

    UserId.fromJson(Map<String, dynamic> json) {
        id = json["_id"];
        name = json["name"];
        phoneNumber = json["phoneNumber"];
        email = json["email"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        _data["phoneNumber"] = phoneNumber;
        _data["email"] = email;
        return _data;
    }
}