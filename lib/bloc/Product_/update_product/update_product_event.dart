part of 'update_product_bloc.dart';

@immutable
sealed class UpdateProductEvent {}

class FetchUpdateProduct extends UpdateProductEvent {
  final String productId;
  final String productName;
  final String productSubName;
  final String productDescription;
  final String price;
  final dynamic imageFile; // Image is optional
  final String unit;
  final String categoryId;
  final String discountPercentage; // Already a string, but good to confirm
  final List<String> selectableQuantities;

  FetchUpdateProduct({
    required this.productId,
    required this.productName,
    required this.productSubName,
    required this.productDescription,
    required this.price,
    this.imageFile,
    required this.unit,
    required this.categoryId,
    required this.discountPercentage,
    required this.selectableQuantities,
  });
}
