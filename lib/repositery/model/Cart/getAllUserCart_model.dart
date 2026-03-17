
class GetAllUserCartModel {
    bool? success;
    Data? data;

    GetAllUserCartModel({this.success, this.data});

    GetAllUserCartModel.fromJson(Map<String, dynamic> json) {
        if(json["success"] is bool) {
            success = json["success"];
        }
        if(json["data"] is Map) {
            data = json["data"] == null ? null : Data.fromJson(json["data"]);
        }
    }

    static List<GetAllUserCartModel> fromList(List<Map<String, dynamic>> list) {
        return list.map(GetAllUserCartModel.fromJson).toList();
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
    List<Items>? items;
    double? totalAmount;

    Data({this.items, this.totalAmount});

    Data.fromJson(Map<String, dynamic> json) {
        if(json["items"] is List) {
            items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
        }
        if(json["totalAmount"] is num) {
            totalAmount = (json["totalAmount"] as num).toDouble();
        }
    }

    static List<Data> fromList(List<Map<String, dynamic>> list) {
        return list.map(Data.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(items != null) {
            _data["items"] = items?.map((e) => e.toJson()).toList();
        }
        _data["totalAmount"] = totalAmount;
        return _data;
    }
}

class Items {
    String? id;
    String? userId;
    String? productId;
    double? quantity;
    String? unit;
    String? createdAt;
    String? updatedAt;
    int? v;
    Product? product;
    double? discountedUnitPrice;
    double? itemAmount;

    Items({this.id, this.userId, this.productId, this.quantity, this.unit, this.createdAt, this.updatedAt, this.v, this.product, this.discountedUnitPrice, this.itemAmount});

    Items.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["userId"] is String) {
            userId = json["userId"];
        }
        if(json["productId"] is String) {
            productId = json["productId"];
        }
        if(json["quantity"] is num) {
            quantity = (json["quantity"] as num).toDouble();
        }
        if(json["unit"] is String) {
            unit = json["unit"];
        }
        if(json["createdAt"] is String) {
            createdAt = json["createdAt"];
        }
        if(json["updatedAt"] is String) {
            updatedAt = json["updatedAt"];
        }
        if(json["__v"] is num) {
            v = (json["__v"] as num).toInt();
        }
        if(json["product"] is Map) {
            product = json["product"] == null ? null : Product.fromJson(json["product"]);
        }
        if(json["discountedUnitPrice"] is num) {
            discountedUnitPrice = (json["discountedUnitPrice"] as num).toDouble();
        }
        if(json["itemAmount"] is num) {
            itemAmount = (json["itemAmount"] as num).toDouble();
        }
    }

    static List<Items> fromList(List<Map<String, dynamic>> list) {
        return list.map(Items.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["userId"] = userId;
        _data["productId"] = productId;
        _data["quantity"] = quantity;
        _data["unit"] = unit;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        if(product != null) {
            _data["product"] = product?.toJson();
        }
        _data["discountedUnitPrice"] = discountedUnitPrice;
        _data["itemAmount"] = itemAmount;
        return _data;
    }
}

class Product {
    String? id;
    String? name;
    String? description;
    String? subName;
    String? details;
    List<String>? images;
    String? category;
    int? basePrice;
    int? discountPercentage;
    String? unit;
    List<double>? selectableQuantities;
    String? slug;
    String? createdAt;
    String? updatedAt;
    int? v;

    Product({this.id, this.name, this.description, this.subName, this.details, this.images, this.category, this.basePrice, this.discountPercentage, this.unit, this.selectableQuantities, this.slug, this.createdAt, this.updatedAt, this.v});

    Product.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["name"] is String) {
            name = json["name"];
        }
        if(json["description"] is String) {
            description = json["description"];
        }
        if(json["subName"] is String) {
            subName = json["subName"];
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
        if(json["basePrice"] is num) {
            basePrice = (json["basePrice"] as num).toInt();
        }
        if(json["discountPercentage"] is num) {
            discountPercentage = (json["discountPercentage"] as num).toInt();
        }
        if(json["unit"] is String) {
            unit = json["unit"];
        }
        if(json["selectableQuantities"] is List) {
            selectableQuantities = json["selectableQuantities"] == null ? null : (json["selectableQuantities"] as List).map((e) => (e as num).toDouble()).toList();
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
        if(json["__v"] is num) {
            v = (json["__v"] as num).toInt();
        }
    }

    static List<Product> fromList(List<Map<String, dynamic>> list) {
        return list.map(Product.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["subName"] = subName;
        _data["details"] = details;
        if(images != null) {
            _data["images"] = images;
        }
        _data["category"] = category;
        _data["basePrice"] = basePrice;
        _data["discountPercentage"] = discountPercentage;
        _data["unit"] = unit;
        if(selectableQuantities != null) {
            _data["selectableQuantities"] = selectableQuantities;
        }
        _data["slug"] = slug;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        return _data;
    }
}