class GetAllForListCategory {
  bool? success;
  List<CategoriesList>? categoriesList;

  GetAllForListCategory({this.success, this.categoriesList});

  GetAllForListCategory.fromJson(Map<String, dynamic> json) {
    if (json["success"] is bool) {
      success = json["success"];
    }
    if (json["categoriesList"] is List) {
      categoriesList = json["categoriesList"] == null
          ? null
          : (json["categoriesList"] as List)
              .map((e) => CategoriesList.fromJson(e))
              .toList();
    }
  }

  static List<GetAllForListCategory> fromList(List<Map<String, dynamic>> list) {
    return list.map(GetAllForListCategory.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    if (categoriesList != null) {
      _data["categoriesList"] = categoriesList?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class CategoriesList {
  String? id;
  String? name;

  CategoriesList({this.id, this.name});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  static List<CategoriesList> fromList(List<Map<String, dynamic>> list) {
    return list.map(CategoriesList.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["_id"] = id;
    _data["name"] = name;
    return _data;
  }
}
