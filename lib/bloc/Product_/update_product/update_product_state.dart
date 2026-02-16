part of 'update_product_bloc.dart';

@immutable
sealed class UpdateProductState {}

final class UpdateProductInitial extends UpdateProductState {}

final class UpdateProductLoading extends UpdateProductState {}

final class UpdateProductLoaded extends UpdateProductState {
  final UpdateProductModel updateProduct;
  UpdateProductLoaded({required this.updateProduct});
}

final class UpdateProductError extends UpdateProductState {
  final String message;
  UpdateProductError({required this.message});
}