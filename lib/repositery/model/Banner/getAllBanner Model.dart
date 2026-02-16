// get_all_banner_model.dart

class GetAllBannerModel {
  final bool success;
  final List<BannerItem> banners;

  GetAllBannerModel({
    required this.success,
    required this.banners,
  });

  factory GetAllBannerModel.fromJson(Map<String, dynamic> json) {
    return GetAllBannerModel(
      success: json['success'] ?? false,
      banners: (json['banners'] as List<dynamic>? ?? [])
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BannerItem {
  final String id;
  final List<String> images;
  final String title;
  final String category;
  final String type;
  final String? productId;
  final BannerCategory? categoryId;
  final String? link;

  BannerItem({
    required this.id,
    required this.images,
    required this.title,
    required this.category,
    required this.type,
    this.productId,
    this.categoryId,
    this.link,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['_id']?.toString() ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      productId: json['productId']?.toString(),
      categoryId: json['categoryId'] != null
          ? BannerCategory.fromJson(json['categoryId'] as Map<String, dynamic>)
          : null,
      link: json['link']?.toString(),
    );
  }
}

class BannerCategory {
  final String id;
  final String name;

  BannerCategory({
    required this.id,
    required this.name,
  });

  factory BannerCategory.fromJson(Map<String, dynamic> json) {
    return BannerCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
