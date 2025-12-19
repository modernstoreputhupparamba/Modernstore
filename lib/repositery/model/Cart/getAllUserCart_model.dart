class GetAllUserCartModel {
  bool? success;
  Data? data;

  GetAllUserCartModel({this.success, this.data});

  GetAllUserCartModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? totalCartLength;
  num? totalCartAmount;
  List<AllCartItems>? allCartItems;

  Data({this.totalCartLength, this.totalCartAmount, this.allCartItems});

  Data.fromJson(Map<String, dynamic> json) {
    totalCartLength = json["totalCartLength"];
    totalCartAmount = json["totalCartAmount"];
    allCartItems = json["AllCartItems"] == null
        ? null
        : (json["AllCartItems"] as List)
            .map((e) => AllCartItems.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["totalCartLength"] = totalCartLength;
    _data["totalCartAmount"] = totalCartAmount;
    if (allCartItems != null) {
      _data["AllCartItems"] = allCartItems?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class AllCartItems {
  String? id;
  String? userId;
  ProductId? productId;
  num? quantity;
  String? unit;
  num? totalAmount;
  String? createdAt;
  String? updatedAt;
  int? v;

  AllCartItems(
      {this.id,
      this.userId,
      this.productId,
      this.quantity,
      this.unit,
      this.totalAmount,
      this.createdAt,
      this.updatedAt,
      this.v});

  AllCartItems.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    userId = json["userId"];
    productId = json["productId"] == null
        ? null
        : ProductId.fromJson(json["productId"]);
    quantity = json["quantity"];
    unit = json["unit"];
    totalAmount = (json["totalAmount"] as num?)?.toDouble();
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    v = json["__v"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["userId"] = userId;
    if (productId != null) {
      _data["productId"] = productId?.toJson();
    }
    _data["quantity"] = quantity;
    _data["unit"] = unit;
    _data["totalAmount"] = totalAmount;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["__v"] = v;
    return _data;
  }
}

class ProductId {
  String? id;
  String? name;

  ProductId({this.id, this.name});

  ProductId.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    return _data;
  }
}
