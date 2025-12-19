class CreateOrderModel {
    bool? success;
    Order? order;

    CreateOrderModel({this.success, this.order});

    CreateOrderModel.fromJson(Map<String, dynamic> json) {
        success = json["success"];
        order = json["order"] == null ? null : Order.fromJson(json["order"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["success"] = success;
        if(order != null) {
            _data["order"] = order?.toJson();
        }
        return _data;
    }
}

class Order {
    String? userId;
    String? orderNo;
    List<String>? orderItems;
    String? shippingAddress;
    String? paymentMethod;
    int? itemsTotalAmount;
    int? deliveryCharge;
    int? finalAmount;
    String? orderStatus;
    List<StatusHistory>? statusHistory;
    String? id;
    String? createdAt;
    String? updatedAt;
    int? v;

    Order({this.userId, this.orderNo, this.orderItems, this.shippingAddress, this.paymentMethod, this.itemsTotalAmount, this.deliveryCharge, this.finalAmount, this.orderStatus, this.statusHistory, this.id, this.createdAt, this.updatedAt, this.v});

    Order.fromJson(Map<String, dynamic> json) {
        userId = json["userId"];
        orderNo = json["orderNo"];
        orderItems = json["orderItems"] == null ? null : List<String>.from(json["orderItems"]);
        shippingAddress = json["shippingAddress"];
        paymentMethod = json["paymentMethod"];
        itemsTotalAmount = json["itemsTotalAmount"];
        deliveryCharge = json["deliveryCharge"];
        finalAmount = json["finalAmount"];
        orderStatus = json["orderStatus"];
        statusHistory = json["statusHistory"] == null ? null : (json["statusHistory"] as List).map((e) => StatusHistory.fromJson(e)).toList();
        id = json["_id"];
        createdAt = json["createdAt"];
        updatedAt = json["updatedAt"];
        v = json["__v"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["userId"] = userId;
        _data["orderNo"] = orderNo;
        if(orderItems != null) {
            _data["orderItems"] = orderItems;
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
        _data["_id"] = id;
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