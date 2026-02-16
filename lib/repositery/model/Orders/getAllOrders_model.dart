
class GetAllOrdersModel {
    bool? success;
    List<Orders>? orders;

    GetAllOrdersModel({this.success, this.orders});

    GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
        if(json["success"] is bool) {
            success = json["success"];
        }
        if(json["orders"] is List) {
            orders = json["orders"] == null ? null : (json["orders"] as List).map((e) => Orders.fromJson(e)).toList();
        }
    }

    static List<GetAllOrdersModel> fromList(List<Map<String, dynamic>> list) {
        return list.map(GetAllOrdersModel.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        if(orders != null) {
            _data["orders"] = orders?.map((e) => e.toJson()).toList();
        }
        return _data;
    }

    GetAllOrdersModel copyWith({
        bool? success,
        List<Orders>? orders,
    }) => GetAllOrdersModel(
        success: success ?? this.success,
        orders: orders ?? this.orders,
    );
}

class Orders {
    String? id;
    UserId? userId;
    String? orderNo;
    List<OrderItems>? orderItems;
    dynamic shippingAddress;
    String? paymentMethod;
    int? itemsTotalAmount;
    int? deliveryCharge;
    int? finalAmount;
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
        if(json["userId"] is Map) {
            userId = json["userId"] == null ? null : UserId.fromJson(json["userId"]);
        }
        if(json["orderNo"] is String) {
            orderNo = json["orderNo"];
        }
        if(json["orderItems"] is List) {
            orderItems = json["orderItems"] == null ? null : (json["orderItems"] as List).map((e) => OrderItems.fromJson(e)).toList();
        }
        shippingAddress = json["shippingAddress"];
        if(json["paymentMethod"] is String) {
            paymentMethod = json["paymentMethod"];
        }
        if(json["itemsTotalAmount"] is num) {
            itemsTotalAmount = (json["itemsTotalAmount"] as num).toInt();
        }
        if(json["deliveryCharge"] is num) {
            deliveryCharge = (json["deliveryCharge"] as num).toInt();
        }
        if(json["finalAmount"] is num) {
            finalAmount = (json["finalAmount"] as num).toInt();
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
        if(userId != null) {
            _data["userId"] = userId?.toJson();
        }
        _data["orderNo"] = orderNo;
        if(orderItems != null) {
            _data["orderItems"] = orderItems?.map((e) => e.toJson()).toList();
        }
        _data["shippingAddress"] = shippingAddress;
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

    Orders copyWith({
        String? id,
        UserId? userId,
        String? orderNo,
        List<OrderItems>? orderItems,
        dynamic shippingAddress,
        String? paymentMethod,
        int? itemsTotalAmount,
        int? deliveryCharge,
        int? finalAmount,
        String? orderStatus,
        List<StatusHistory>? statusHistory,
        String? createdAt,
        String? updatedAt,
        int? v,
    }) => Orders(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        orderNo: orderNo ?? this.orderNo,
        orderItems: orderItems ?? this.orderItems,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        itemsTotalAmount: itemsTotalAmount ?? this.itemsTotalAmount,
        deliveryCharge: deliveryCharge ?? this.deliveryCharge,
        finalAmount: finalAmount ?? this.finalAmount,
        orderStatus: orderStatus ?? this.orderStatus,
        statusHistory: statusHistory ?? this.statusHistory,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
    );
}

class StatusHistory {
    dynamic cancelledBy;
    String? status;
    String? particular;
    String? id;
    String? changedAt;

    StatusHistory({this.cancelledBy, this.status, this.particular, this.id, this.changedAt});

    StatusHistory.fromJson(Map<String, dynamic> json) {
        cancelledBy = json["cancelledBy"];
        if(json["status"] is String) {
            status = json["status"];
        }
        if(json["particular"] is String) {
            particular = json["particular"];
        }
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
        _data["cancelledBy"] = cancelledBy;
        _data["status"] = status;
        _data["particular"] = particular;
        _data["_id"] = id;
        _data["changedAt"] = changedAt;
        return _data;
    }

    StatusHistory copyWith({
        dynamic cancelledBy,
        String? status,
        String? particular,
        String? id,
        String? changedAt,
    }) => StatusHistory(
        cancelledBy: cancelledBy ?? this.cancelledBy,
        status: status ?? this.status,
        particular: particular ?? this.particular,
        id: id ?? this.id,
        changedAt: changedAt ?? this.changedAt,
    );
}

class OrderItems {
    String? id;
    String? orderId;
    ProductId? productId;
    int? quantity;
    int? itemTotalAmount;
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
            itemTotalAmount = (json["itemTotalAmount"] as num).toInt();
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

    OrderItems copyWith({
        String? id,
        String? orderId,
        ProductId? productId,
        int? quantity,
        int? itemTotalAmount,
        int? v,
        String? createdAt,
        String? updatedAt,
    }) => OrderItems(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        itemTotalAmount: itemTotalAmount ?? this.itemTotalAmount,
        v: v ?? this.v,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
    );
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

    ProductId copyWith({
        String? id,
        String? name,
        List<String>? images,
        int? basePrice,
        int? discountPercentage,
        String? unit,
    }) => ProductId(
        id: id ?? this.id,
        name: name ?? this.name,
        images: images ?? this.images,
        basePrice: basePrice ?? this.basePrice,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        unit: unit ?? this.unit,
    );
}

class UserId {
    String? id;
    dynamic name;
    dynamic email;

    UserId({this.id, this.name, this.email});

    UserId.fromJson(Map<String, dynamic> json) {
        if(json["_id"] is String) {
            id = json["_id"];
        }
        name = json["name"];
        email = json["email"];
    }

    static List<UserId> fromList(List<Map<String, dynamic>> list) {
        return list.map(UserId.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        _data["email"] = email;
        return _data;
    }

    UserId copyWith({
        String? id,
        dynamic name,
        dynamic email,
    }) => UserId(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
    );
}