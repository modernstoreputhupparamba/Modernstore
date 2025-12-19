
class DashboardModel {
    bool? success;
    Data? data;

    DashboardModel({this.success, this.data});

    DashboardModel.fromJson(Map<String, dynamic> json) {
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
    int? totalUsers;
    int? totalProducts;
    int? totalCategories;
    int? totalOrders;
    int? newOrders;
    int? shippedOrders;
    int? deliveredOrders;
    int? canceledOrders;
    int? totalRevenue;
    List<dynamic>? topCategories;
    int? currentMonthDeliveredOrders;

    Data({this.totalUsers, this.totalProducts, this.totalCategories, this.totalOrders, this.newOrders, this.shippedOrders, this.deliveredOrders, this.canceledOrders, this.totalRevenue, this.topCategories, this.currentMonthDeliveredOrders});

    Data.fromJson(Map<String, dynamic> json) {
        totalUsers = json["totalUsers"];
        totalProducts = json["totalProducts"];
        totalCategories = json["totalCategories"];
        totalOrders = json["totalOrders"];
        newOrders = json["newOrders"];
        shippedOrders = json["shippedOrders"];
        deliveredOrders = json["deliveredOrders"];
        canceledOrders = json["canceledOrders"];
        totalRevenue = json["totalRevenue"];
        topCategories = json["topCategories"] ?? [];
        currentMonthDeliveredOrders = json["currentMonthDeliveredOrders"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["totalUsers"] = totalUsers;
        _data["totalProducts"] = totalProducts;
        _data["totalCategories"] = totalCategories;
        _data["totalOrders"] = totalOrders;
        _data["newOrders"] = newOrders;
        _data["shippedOrders"] = shippedOrders;
        _data["deliveredOrders"] = deliveredOrders;
        _data["canceledOrders"] = canceledOrders;
        _data["totalRevenue"] = totalRevenue;
        if(topCategories != null) {
            _data["topCategories"] = topCategories;
        }
        _data["currentMonthDeliveredOrders"] = currentMonthDeliveredOrders;
        return _data;
    }
}