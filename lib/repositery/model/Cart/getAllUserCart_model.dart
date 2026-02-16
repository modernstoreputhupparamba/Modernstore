
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

    GetAllUserCartModel copyWith({
        bool? success,
        Data? data,
    }) => GetAllUserCartModel(
        success: success ?? this.success,
        data: data ?? this.data,
    );
}

class Data {
    int? totalCartLength;
    double? totalCartAmount;
    List<AllCartItems>? allCartItems;

    Data({this.totalCartLength, this.totalCartAmount, this.allCartItems});

    Data.fromJson(Map<String, dynamic> json) {
        if(json["totalCartLength"] is num) {
            totalCartLength = (json["totalCartLength"] as num).toInt();
        }
        if(json["totalCartAmount"] is num) {
            totalCartAmount = (json["totalCartAmount"] as num).toDouble();
        }
        if(json["AllCartItems"] is List) {
            allCartItems = json["AllCartItems"] == null ? null : (json["AllCartItems"] as List).map((e) => AllCartItems.fromJson(e)).toList();
        }
    }

    static List<Data> fromList(List<Map<String, dynamic>> list) {
        return list.map(Data.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["totalCartLength"] = totalCartLength;
        _data["totalCartAmount"] = totalCartAmount;
        if(allCartItems != null) {
            _data["AllCartItems"] = allCartItems?.map((e) => e.toJson()).toList();
        }
        return _data;
    }

    Data copyWith({
        int? totalCartLength,
        double? totalCartAmount,
        List<AllCartItems>? allCartItems,
    }) => Data(
        totalCartLength: totalCartLength ?? this.totalCartLength,
        totalCartAmount: totalCartAmount ?? this.totalCartAmount,
        allCartItems: allCartItems ?? this.allCartItems,
    );
}

class AllCartItems {
    String? id;
    int? quantity;
    String? unit;
    double? totalAmount;
    Product? product;

    AllCartItems({this.id, this.quantity, this.unit, this.totalAmount, this.product});

    AllCartItems.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["quantity"] is num) {
            quantity = (json["quantity"] as num).toInt();
        }
        if(json["unit"] is String) {
            unit = json["unit"];
        }
        if(json["totalAmount"] is num) {
            totalAmount = (json["totalAmount"] as num).toDouble();
        }
        if(json["product"] is Map) {
            product = json["product"] == null ? null : Product.fromJson(json["product"]);
        }
    }

    static List<AllCartItems> fromList(List<Map<String, dynamic>> list) {
        return list.map(AllCartItems.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["quantity"] = quantity;
        _data["unit"] = unit;
        _data["totalAmount"] = totalAmount;
        if(product != null) {
            _data["product"] = product?.toJson();
        }
        return _data;
    }

    AllCartItems copyWith({
        String? id,
        int? quantity,
        String? unit,
        double? totalAmount,
        Product? product,
    }) => AllCartItems(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        totalAmount: totalAmount ?? this.totalAmount,
        product: product ?? this.product,
    );
}

class Product {
    String? id;
    String? name;
    List<String>? images;
    int? basePrice;
    int? availableStock;

    Product({this.id, this.name, this.images, this.basePrice, this.availableStock});

    Product.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["name"] is String) {
            name = json["name"];
        }
        if(json["images"] is List) {
            images = json["images"] == null ? null : List<String>.from(json["images"]);
        }
        if(json["basePrice"] is num) {
            basePrice = (json["basePrice"] as num).toInt();
        }
        if(json["availableStock"] is num) {
            availableStock = (json["availableStock"] as num).toInt();
        }
    }

    static List<Product> fromList(List<Map<String, dynamic>> list) {
        return list.map(Product.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        if(images != null) {
            _data["images"] = images;
        }
        _data["basePrice"] = basePrice;
        _data["availableStock"] = availableStock;
        return _data;
    }

    Product copyWith({
        String? id,
        String? name,
        List<String>? images,
        int? basePrice,
        int? availableStock,
    }) => Product(
        id: id ?? this.id,
        name: name ?? this.name,
        images: images ?? this.images,
        basePrice: basePrice ?? this.basePrice,
        availableStock: availableStock ?? this.availableStock,
    );
}