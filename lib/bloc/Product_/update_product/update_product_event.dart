part of 'update_product_bloc.dart';

@immutable
sealed class UpdateProductEvent {}

class FetchUpdateProduct extends UpdateProductEvent {
  final String productId;
  final String productName;
  final String productDescription;
  final String price;
  final File? imageFile; // Image is optional
  final String unit;
  final String categoryId;
  final String discountPercentage; // Already a string, but good to confirm

  FetchUpdateProduct({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.price,
    this.imageFile,
    required this.unit,
    required this.categoryId,
    required this.discountPercentage,
  });
}