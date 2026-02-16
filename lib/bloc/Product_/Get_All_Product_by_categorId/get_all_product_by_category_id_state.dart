part of 'get_all_product_by_category_id_bloc.dart';

@immutable
sealed class GetAllProductByCategoryIdState {}

final class GetAllProductByCategoryIdInitial extends GetAllProductByCategoryIdState {}

final class GetAllProductByCategoryIdLoading extends GetAllProductByCategoryIdState {}

final class GetAllProductByCategoryIdLoaded extends GetAllProductByCategoryIdState {
  final GetAllProductByCategoryIdModel products;
  GetAllProductByCategoryIdLoaded(this.products);
}

final class GetAllProductByCategoryIdError extends GetAllProductByCategoryIdState {
  final String errorMessage;
  GetAllProductByCategoryIdError(this.errorMessage);
}