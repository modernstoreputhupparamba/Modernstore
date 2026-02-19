class GetAllProduct {
  bool? success;
  List<Data>? data;

  GetAllProduct({this.success, this.data});

  GetAllProduct.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
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
  String? name;
  String? description;
  String? details;
  List<String>? images;
  Category? category;
  num? basePrice;
  num? discountPercentage;
  String? unit;
  String? sku;
  String? slug;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? inWishlist;

  Data(
      {this.id,
      this.name,
      this.description,
      this.details,
      this.images,
      this.category,
      this.basePrice,
      this.discountPercentage,
      this.unit,
      this.sku,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.inWishlist});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    description = json["description"];
    details = json["details"];
    images = json["images"] == null ? null : List<String>.from(json["images"]);
    category =
        json["category"] == null ? null : Category.fromJson(json["category"]);
    basePrice = json["basePrice"];
    discountPercentage = json["discountPercentage"];
    unit = json["unit"];
    sku = json["sku"];
    slug = json["slug"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    v = json["__v"];
    inWishlist = json["inWishlist"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["details"] = details;
    if (images != null) {
      _data["images"] = images;
    }
    if (category != null) {
      _data["category"] = category?.toJson();
    }
    _data["basePrice"] = basePrice;
    _data["discountPercentage"] = discountPercentage;
    _data["unit"] = unit;
    _data["sku"] = sku;
    _data["slug"] = slug;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    _data["__v"] = v;
    _data["inWishlist"] = inWishlist;
    return _data;
  }
}

class Category {
  String? id;
  String? name;
  String? description;
  String? image;
  int? v;

  Category({this.id, this.name, this.description, this.image, this.v});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    description = json["description"];
    image = json["image"];
    v = json["__v"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["image"] = image;
    _data["__v"] = v;
    return _data;
  }
}
