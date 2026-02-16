
class CreateProductModel {
    bool? success;
    Data? data;

    CreateProductModel({this.success, this.data});

    CreateProductModel.fromJson(Map<String, dynamic> json) {
        success = json["success"];
        data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        if(data != null) {
            _data["data"] = data?.toJson();
        }
        return _data;
    }
}

class Data {
    String? message;
    Product? product;

    Data({this.message, this.product});

    Data.fromJson(Map<String, dynamic> json) {
        message = json["message"];
        product = json["product"] == null ? null : Product.fromJson(json["product"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["message"] = message;
        if(product != null) {
            _data["product"] = product?.toJson();
        }
        return _data;
    }
}

class Product {
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
    String? id;
    String? createdAt;
    String? updatedAt;
    int? v;

    Product({this.name, this.description, this.details, this.images, this.category, this.basePrice, this.discountPercentage, this.unit, this.sku, this.slug, this.id, this.createdAt, this.updatedAt, this.v});

    Product.fromJson(Map<String, dynamic> json) {
        name = json["name"];
        description = json["description"];
        details = json["details"];
        images = json["images"] == null ? null : List<String>.from(json["images"]);
        category = json["category"];
        basePrice = json["basePrice"];
        discountPercentage = json["discountPercentage"];
        unit = json["unit"];
        sku = json["sku"];
        slug = json["slug"];
        id = json["_id"];
        createdAt = json["createdAt"];
        updatedAt = json["updatedAt"];
        v = json["__v"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
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
        _data["_id"] = id;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        return _data;
    }
}