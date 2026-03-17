
class DashboardModel {
    bool? success;
    Data? data;

    DashboardModel({this.success, this.data});

    DashboardModel.fromJson(Map<String, dynamic> json) {
        if(json["success"] is bool) {
            success = json["success"];
        }
        if(json["data"] is Map) {
            data = json["data"] == null ? null : Data.fromJson(json["data"]);
        }
    }

    static List<DashboardModel> fromList(List<Map<String, dynamic>> list) {
        return list.map(DashboardModel.fromJson).toList();
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
    double? totalRevenue;
    int? totalOrders;
    OrderStats? orderStats;
    List<TopCategories>? topCategories;
    List<MonthlyOrders>? monthlyOrders;

    Data({this.totalUsers, this.totalProducts, this.totalCategories, this.totalRevenue, this.totalOrders, this.orderStats, this.topCategories, this.monthlyOrders});

    Data.fromJson(Map<String, dynamic> json) {
        if(json["totalUsers"] is num) {
            totalUsers = (json["totalUsers"] as num).toInt();
        }
        if(json["totalProducts"] is num) {
            totalProducts = (json["totalProducts"] as num).toInt();
        }
        if(json["totalCategories"] is num) {
            totalCategories = (json["totalCategories"] as num).toInt();
        }
        if(json["totalRevenue"] is num) {
            totalRevenue = (json["totalRevenue"] as num).toDouble();
        }
        if(json["totalOrders"] is num) {
            totalOrders = (json["totalOrders"] as num).toInt();
        }
        if(json["orderStats"] is Map) {
            orderStats = json["orderStats"] == null ? null : OrderStats.fromJson(json["orderStats"]);
        }
        if(json["topCategories"] is List) {
            topCategories = json["topCategories"] == null ? null : (json["topCategories"] as List).map((e) => TopCategories.fromJson(e)).toList();
        }
        if(json["monthlyOrders"] is List) {
            monthlyOrders = json["monthlyOrders"] == null ? null : (json["monthlyOrders"] as List).map((e) => MonthlyOrders.fromJson(e)).toList();
        }
    }

    static List<Data> fromList(List<Map<String, dynamic>> list) {
        return list.map(Data.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["totalUsers"] = totalUsers;
        _data["totalProducts"] = totalProducts;
        _data["totalCategories"] = totalCategories;
        _data["totalRevenue"] = totalRevenue;
        _data["totalOrders"] = totalOrders;
        if(orderStats != null) {
            _data["orderStats"] = orderStats?.toJson();
        }
        if(topCategories != null) {
            _data["topCategories"] = topCategories?.map((e) => e.toJson()).toList();
        }
        if(monthlyOrders != null) {
            _data["monthlyOrders"] = monthlyOrders?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class MonthlyOrders {
    String? month;
    int? count;

    MonthlyOrders({this.month, this.count});

    MonthlyOrders.fromJson(Map<String, dynamic> json) {
        if(json["month"] is String) {
            month = json["month"];
        }
        if(json["count"] is num) {
            count = (json["count"] as num).toInt();
        }
    }

    static List<MonthlyOrders> fromList(List<Map<String, dynamic>> list) {
        return list.map(MonthlyOrders.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["month"] = month;
        _data["count"] = count;
        return _data;
    }
}

class TopCategories {
    String? categoryId;
    String? name;
    int? count;
    int? percentage;

    TopCategories({this.categoryId, this.name, this.count, this.percentage});

    TopCategories.fromJson(Map<String, dynamic> json) {
        if(json["categoryId"] is String) {
            categoryId = json["categoryId"];
        }
        if(json["name"] is String) {
            name = json["name"];
        }
        if(json["count"] is num) {
            count = (json["count"] as num).toInt();
        }
        if(json["percentage"] is num) {
            percentage = (json["percentage"] as num).toInt();
        }
    }

    static List<TopCategories> fromList(List<Map<String, dynamic>> list) {
        return list.map(TopCategories.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["categoryId"] = categoryId;
        _data["name"] = name;
        _data["count"] = count;
        _data["percentage"] = percentage;
        return _data;
    }
}

class OrderStats {
    int? newOrders;
    int? outForDelivery;
    int? delivered;
    int? cancelled;

    OrderStats({this.newOrders, this.outForDelivery, this.delivered, this.cancelled});

    OrderStats.fromJson(Map<String, dynamic> json) {
        if(json["newOrders"] is num) {
            newOrders = (json["newOrders"] as num).toInt();
        }
        if(json["outForDelivery"] is num) {
            outForDelivery = (json["outForDelivery"] as num).toInt();
        }
        if(json["delivered"] is num) {
            delivered = (json["delivered"] as num).toInt();
        }
        if(json["cancelled"] is num) {
            cancelled = (json["cancelled"] as num).toInt();
        }
    }

    static List<OrderStats> fromList(List<Map<String, dynamic>> list) {
        return list.map(OrderStats.fromJson).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["newOrders"] = newOrders;
        _data["outForDelivery"] = outForDelivery;
        _data["delivered"] = delivered;
        _data["cancelled"] = cancelled;
        return _data;
    }
}