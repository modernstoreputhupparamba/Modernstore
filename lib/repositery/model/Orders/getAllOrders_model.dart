class GetAllOrdersModel {
    bool? success;
    List<Orders>? orders;

    GetAllOrdersModel({this.success, this.orders});

    GetAllOrdersModel.fromJson(Map<String, dynamic> json) {
        success = json["success"];
        orders = json["orders"] == null ? null : (json["orders"] as List).map((e) => Orders.fromJson(e)).toList();
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
        id = json["_id"];
        userId = json["userId"] == null ? null : UserId.fromJson(json["userId"]);
        orderNo = json["orderNo"];
        orderItems = json["orderItems"] == null ? null : (json["orderItems"] as List).map((e) => OrderItems.fromJson(e)).toList();
        shippingAddress = json["shippingAddress"];
        paymentMethod = json["paymentMethod"];
        itemsTotalAmount = json["itemsTotalAmount"];
        deliveryCharge = json["deliveryCharge"];
        finalAmount = json["finalAmount"];
        orderStatus = json["orderStatus"];
        statusHistory = json["statusHistory"] == null ? null : (json["statusHistory"] as List).map((e) => StatusHistory.fromJson(e)).toList();
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
}

class StatusHistory {
    String? status;
    String? particular;
    String? id;
    String? changedAt;

    StatusHistory({this.status, this.particular, this.id, this.changedAt});

    StatusHistory.fromJson(Map<String, dynamic> json) {
        status = json["status"];
        particular = json["particular"];
        id = json["_id"];
        changedAt = json["changedAt"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["status"] = status;
        _data["particular"] = particular;
        _data["_id"] = id;
        _data["changedAt"] = changedAt;
        return _data;
    }
}

class OrderItems {
    String? id;
    String? orderId;
    String? productId;
    int? quantity;
    int? itemTotalAmount;
    int? v;
    String? createdAt;
    String? updatedAt;

    OrderItems({this.id, this.orderId, this.productId, this.quantity, this.itemTotalAmount, this.v, this.createdAt, this.updatedAt});

    OrderItems.fromJson(Map<String, dynamic> json) {
        id = json["_id"];
        orderId = json["orderId"];
        productId = json["productId"];
        quantity = json["quantity"];
        itemTotalAmount = json["itemTotalAmount"];
        v = json["__v"];
        createdAt = json["createdAt"];
        updatedAt = json["updatedAt"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["orderId"] = orderId;
        _data["productId"] = productId;
        _data["quantity"] = quantity;
        _data["itemTotalAmount"] = itemTotalAmount;
        _data["__v"] = v;
        _data["createdAt"] = createdAt;
        _data["updatedAt"] = updatedAt;
        return _data;
    }
}

class UserId {
    String? id;
    dynamic name;
    dynamic email;

    UserId({this.id, this.name, this.email});

    UserId.fromJson(Map<String, dynamic> json) {
        id = json["_id"];
        name = json["name"];
        email = json["email"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["_id"] = id;
        _data["name"] = name;
        _data["email"] = email;
        return _data;
    }
}