class GetAllnventory {
  bool? success;
  List<Data>? data;

  GetAllnventory({this.success, this.data});

  GetAllnventory.fromJson(Map<String, dynamic> json) {
    if (json["success"] is bool) {
      success = json["success"];
    }
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  static List<GetAllnventory> fromList(List<Map<String, dynamic>> list) {
    return list.map(GetAllnventory.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? id;
  ProductId? productId;
  String? sku;
  String? unit;
  int? quantityInStock;
  int? soldQuantity;
  int? totalStock;
  String? createdAt;
  String? updatedAt;
  int? v;

  Data(
      {this.id,
      this.productId,
      this.sku,
      this.unit,
      this.quantityInStock,
      this.soldQuantity,
      this.totalStock,
      this.createdAt,
      this.updatedAt,
      this.v});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["productId"] is Map) {
      productId = json["productId"] == null
          ? null
          : ProductId.fromJson(json["productId"]);
    }
    if (json["SKU"] is String) {
      sku = json["SKU"];
    }
    if (json["unit"] is String) {
      unit = json["unit"];
    }
    if (json["quantityInStock"] is int) {
      quantityInStock = json["quantityInStock"];
    }
    if (json["soldQuantity"] is int) {
      soldQuantity = json["soldQuantity"];
    }
    if (json["totalStock"] is int) {
      totalStock = json["totalStock"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if (json["__v"] is int) {
      v = json["__v"];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    if (productId != null) {
      _data["productId"] = productId?.toJson();
    }
    _data["SKU"] = sku;
    _data["unit"] = unit;
    _data["quantityInStock"] = quantityInStock;
    _data["soldQuantity"] = soldQuantity;
    _data["totalStock"] = totalStock;
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
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  static List<ProductId> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProductId.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    return _data;
  }
}
