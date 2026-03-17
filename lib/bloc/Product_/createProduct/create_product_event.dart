part of 'create_product_bloc.dart';

@immutable
sealed class CreateProductEvent {}

class fetchCreateProduct extends CreateProductEvent {
  final String productName;
 final String productSubName;
  final String productDescription;
  final String price;
  final File imageFile;
  final String unit;
  final dynamic categoryId;
  final String discountPercentage;
  final List<String> selectableQuantities;


  fetchCreateProduct(
      {required this.productName,
      required this.productSubName,
      required this.productDescription,
      required this.price,
      required this.imageFile,
      required this.unit,
      required this.categoryId,
      required this.discountPercentage,
       required this.selectableQuantities});
}
