part of 'delete_product_bloc.dart';

@immutable
sealed class DeleteProductEvent {}

class FetchDeleteProduct extends DeleteProductEvent {
  final String productId;

  FetchDeleteProduct({required this.productId});
}