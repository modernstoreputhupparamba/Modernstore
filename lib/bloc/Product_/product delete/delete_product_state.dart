part of 'delete_product_bloc.dart';

@immutable
sealed class DeleteProductState {}

final class DeleteProductInitial extends DeleteProductState {}

final class DeleteProductLoading extends DeleteProductState {}

final class DeleteProductLoaded extends DeleteProductState {
  final DeleteProductModel deleteProductModel;
  DeleteProductLoaded({required this.deleteProductModel});
}

final class DeleteProductError extends DeleteProductState {
  final String message;
  DeleteProductError({required this.message});
}