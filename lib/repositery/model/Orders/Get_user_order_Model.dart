
class GetUserOrderModel {
    bool? success;
    List<Orders>? orders;

    GetUserOrderModel({this.success, this.orders});

    GetUserOrderModel.fromJson(Map<String, dynamic> json) {
        if(json["success"] is bool) {
            success = json["success"];
        }
        if(json["orders"] is List) {
            orders = json["orders"] == null ? null : (json["orders"] as List).map((e) => Orders.fromJson(e)).toList();
        }
    }

    static List<GetUserOrderModel> fromList(List<Map<String, dynamic>> list) {
        return list.map(GetUserOrderModel.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        if(orders != null) {
            _data["orders"] = orders?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Orders {
    String? id;
    String? userId;
    String? orderNo;
    List<OrderItems>? orderItems;
    ShippingAddress? shippingAddress;
    String? paymentMethod;
    double? itemsTotalAmount;
    int? deliveryCharge;
    double? finalAmount;
    String? orderStatus;
    List<StatusHistory>? statusHistory;
    String? createdAt;
    String? updatedAt;
    int? v;

    Orders({this.id, this.userId, this.orderNo, this.orderItems, this.shippingAddress, this.paymentMethod, this.itemsTotalAmount, this.deliveryCharge, this.finalAmount, this.orderStatus, this.statusHistory, this.createdAt, this.updatedAt, this.v});

    Orders.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["userId"] is String) {
            userId = json["userId"];
        }
        if(json["orderNo"] is String) {
            orderNo = json["orderNo"];
        }
        if(json["orderItems"] is List) {
            orderItems = json["orderItems"] == null ? null : (json["orderItems"] as List).map((e) => OrderItems.fromJson(e)).toList();
        }
        if(json["shippingAddress"] is Map) {
            shippingAddress = json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]);
        }
        if(json["paymentMethod"] is String) {
            paymentMethod = json["paymentMethod"];
        }
        if(json["itemsTotalAmount"] is num) {
            itemsTotalAmount = (json["itemsTotalAmount"] as num).toDouble();
        }
        if(json["deliveryCharge"] is num) {
            deliveryCharge = (json["deliveryCharge"] as num).toInt();
        }
        if(json["finalAmount"] is num) {
            finalAmount = (json["finalAmount"] as num).toDouble();
        }
        if(json["orderStatus"] is String) {
            orderStatus = json["orderStatus"];
        }
        if(json["statusHistory"] is List) {
            statusHistory = json["statusHistory"] == null ? null : (json["statusHistory"] as List).map((e) => StatusHistory.fromJson(e)).toList();
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

    static List<Orders> fromList(List<Map<String, dynamic>> list) {
        return list.map(Orders.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["userId"] = userId;
        _data["orderNo"] = orderNo;
        if(orderItems != null) {
            _data["orderItems"] = orderItems?.map((e) => e.toJson()).toList();
        }
        if(shippingAddress != null) {
            _data["shippingAddress"] = shippingAddress?.toJson();
        }
        _data["paymentMethod"] = paymentMethod;
        _data["itemsTotalAmount"] = itemsTotalAmount;
        _data["deliveryCharge"] = deliveryCharge;
        _data["finalAmount"] = finalAmount;
        _data["orderStatus"] = orderStatus;
        if(statusHistory != null) {
            _data["statusHistory"] = statusHistory?.map((e) => e.toJson()).toList();
        }
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        _data["__v"] = v;
        return _data;
    }
}

class StatusHistory {
    String? status;
    String? particular;
    dynamic cancelledBy;
    String? id;
    String? changedAt;

    StatusHistory({this.status, this.particular, this.cancelledBy, this.id, this.changedAt});

    StatusHistory.fromJson(Map<String, dynamic> json) {
        if(json["status"] is String) {
            status = json["status"];
        }
        if(json["particular"] is String) {
            particular = json["particular"];
        }
        cancelledBy = json["cancelledBy"];
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["changedAt"] is String) {
            changedAt = json["changedAt"];
        }
    }

    static List<StatusHistory> fromList(List<Map<String, dynamic>> list) {
        return list.map(StatusHistory.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["status"] = status;
        _data["particular"] = particular;
        _data["cancelledBy"] = cancelledBy;
        _data["_id"] = id;
        _data["changedAt"] = changedAt;
        return _data;
    }
}

class ShippingAddress {
    String? id;
    String? userId;
    String? address;
    String? city;
    String? pincode;
    String? latitude;
    String? longitude;
    String? createdAt;
    String? updatedAt;
    int? v;

    ShippingAddress({this.id, this.userId, this.address, this.city, this.pincode, this.latitude, this.longitude, this.createdAt, this.updatedAt, this.v});

    ShippingAddress.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["userId"] is String) {
            userId = json["userId"];
        }
        if(json["address"] is String) {
            address = json["address"];
        }
        if(json["city"] is String) {
            city = json["city"];
        }
        if(json["pincode"] is String) {
            pincode = json["pincode"];
        }
        if(json["latitude"] is String) {
            latitude = json["latitude"];
        }
        if(json["longitude"] is String) {
            longitude = json["longitude"];
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

    static List<ShippingAddress> fromList(List<Map<String, dynamic>> list) {
        return list.map(ShippingAddress.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["userId"] = userId;
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

class OrderItems {
    String? id;
    String? orderId;
    ProductId? productId;
    int? quantity;
    double? itemTotalAmount;
    int? v;
    String? createdAt;
    String? updatedAt;

    OrderItems({this.id, this.orderId, this.productId, this.quantity, this.itemTotalAmount, this.v, this.createdAt, this.updatedAt});

    OrderItems.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        if(json["orderId"] is String) {
            orderId = json["orderId"];
        }
        if(json["productId"] is Map) {
            productId = json["productId"] == null ? null : ProductId.fromJson(json["productId"]);
        }
        if(json["quantity"] is num) {
            quantity = (json["quantity"] as num).toInt();
        }
        if(json["itemTotalAmount"] is num) {
            itemTotalAmount = (json["itemTotalAmount"] as num).toDouble();
        }
        if(json["__v"] is num) {
            v = (json["__v"] as num).toInt();
        }
        if(json["createdAt"] is String) {
            createdAt = json["createdAt"];
        }
        if(json["updatedAt"] is String) {
            updatedAt = json["updatedAt"];
        }
    }

    static List<OrderItems> fromList(List<Map<String, dynamic>> list) {
        return list.map(OrderItems.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["orderId"] = orderId;
        if(productId != null) {
            _data["productId"] = productId?.toJson();
        }
        _data["quantity"] = quantity;
        _data["itemTotalAmount"] = itemTotalAmount;
        _data["__v"] = v;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        return _data;
    }
}

class ProductId {
    String? id;
    String? name;
    List<String>? images;
    int? basePrice;
    int? discountPercentage;
    String? unit;

    ProductId({this.id, this.name, this.images, this.basePrice, this.discountPercentage, this.unit});

    ProductId.fromJson(Map<String, dynamic> json) {
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
        if(json["discountPercentage"] is num) {
            discountPercentage = (json["discountPercentage"] as num).toInt();
        }
        if(json["unit"] is String) {
            unit = json["unit"];
        }
    }

    static List<ProductId> fromList(List<Map<String, dynamic>> list) {
        return list.map(ProductId.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        if(images != null) {
            _data["images"] = images;
        }
        _data["basePrice"] = basePrice;
        _data["discountPercentage"] = discountPercentage;
        _data["unit"] = unit;
        return _data;
    }
}