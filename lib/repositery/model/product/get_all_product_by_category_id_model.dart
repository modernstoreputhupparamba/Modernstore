class GetAllProductByCategoryIdModel {
  bool? success;
  String? message;
  List<Data>? data;

  GetAllProductByCategoryIdModel({this.success, this.message, this.data});

  GetAllProductByCategoryIdModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? description;
  String? categoryId;
  int? basePrice;
  int? discountedPrice;
  int? discountPercentage;
  String? unit;
  List<String>? images;
  bool? isTrending;
  bool? isOffer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.name,
      this.description,
      this.categoryId,
      this.basePrice,
      this.discountedPrice,
      this.discountPercentage,
      this.unit,
      this.images,
      this.isTrending,
      this.isOffer,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['categoryId'];
    basePrice = json['basePrice'];
    discountedPrice = json['discountedPrice'];
    discountPercentage = json['discountPercentage'];
    unit = json['unit'];
    images = json['images'].cast<String>();
    isTrending = json['isTrending'];
    isOffer = json['isOffer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['categoryId'] = this.categoryId;
    data['basePrice'] = this.basePrice;
    data['discountedPrice'] = this.discountedPrice;
    data['discountPercentage'] = this.discountPercentage;
    data['unit'] = this.unit;
    data['images'] = this.images;
    data['isTrending'] = this.isTrending;
    data['isOffer'] = this.isOffer;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}