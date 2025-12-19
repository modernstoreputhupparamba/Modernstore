part of 'get_all_product_by_category_id_bloc.dart';

@immutable
sealed class GetAllProductByCategoryIdEvent {}

class FetchAllProductByCategoryId extends GetAllProductByCategoryIdEvent {
  final String categoryId;
  FetchAllProductByCategoryId({required this.categoryId});
}