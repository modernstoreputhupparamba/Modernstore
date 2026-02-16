
class AddToWishlistMode {
  bool? success;
  Wishlist? wishlist;

  AddToWishlistMode({this.success, this.wishlist});

  AddToWishlistMode.fromJson(Map<String, dynamic> json) {
    if(json["success"] is bool) {
      success = json["success"];
    }
    if(json["wishlist"] is Map) {
      wishlist = json["wishlist"] == null ? null : Wishlist.fromJson(json["wishlist"]);
    }
  }

  static List<AddToWishlistMode> fromList(List<Map<String, dynamic>> list) {
    return list.map(AddToWishlistMode.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    if(wishlist != null) {
      _data["wishlist"] = wishlist?.toJson();
    }
    return _data;
  }
}

class Wishlist {
  String? userId;
  ProductId? productId;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  Wishlist({this.userId, this.productId, this.id, this.createdAt, this.updatedAt, this.v});

  Wishlist.fromJson(Map<String, dynamic> json) {
    if(json["userId"] is String) {
      userId = json["userId"];
    }
    if(json["productId"] is Map) {
      productId = json["productId"] == null ? null : ProductId.fromJson(json["productId"]);
    }
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if(json["__v"] is int) {
      v = json["__v"];
    }
  }

  static List<Wishlist> fromList(List<Map<String, dynamic>> list) {
    return list.map(Wishlist.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userId"] = userId;
    if(productId != null) {
      _data["productId"] = productId?.toJson();
    }
    _data["_id"] = id;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["__v"] = v;
    return _data;
  }
}

class ProductId {
  String? id;
  String? name;
  String? description;
  String? details;
  List<String>? images;
  String? category;
  int? basePrice;
  int? discountPercentage;
  String? unit;
  String? sku;
  String? slug;
  String? createdAt;
  String? updatedAt;
  int? v;

  ProductId({this.id, this.name, this.description, this.details, this.images, this.category, this.basePrice, this.discountPercentage, this.unit, this.sku, this.slug, this.createdAt, this.updatedAt, this.v});

  ProductId.fromJson(Map<String, dynamic> json) {
    if(json["_id"] is String) {
      id = json["_id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["details"] is String) {
      details = json["details"];
    }
    if(json["images"] is List) {
      images = json["images"] == null ? null : List<String>.from(json["images"]);
    }
    if(json["category"] is String) {
      category = json["category"];
    }
    if(json["basePrice"] is int) {
      basePrice = json["basePrice"];
    }
    if(json["discountPercentage"] is int) {
      discountPercentage = json["discountPercentage"];
    }
    if(json["unit"] is String) {
      unit = json["unit"];
    }
    if(json["sku"] is String) {
      sku = json["sku"];
    }
    if(json["slug"] is String) {
      slug = json["slug"];
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if(json["__v"] is int) {
      v = json["__v"];
    }
  }

  static List<ProductId> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProductId.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["details"] = details;
    if(images != null) {
      _data["images"] = images;
    }
    _data["category"] = category;
    _data["basePrice"] = basePrice;
    _data["discountPercentage"] = discountPercentage;
    _data["unit"] = unit;
    _data["sku"] = sku;
    _data["slug"] = slug;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["__v"] = v;
    return _data;
  }
}