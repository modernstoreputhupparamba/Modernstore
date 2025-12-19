part of 'get_all_product_bloc.dart';

@immutable
sealed class GetAllProductEvent {}

class fetchGetAllProduct extends GetAllProductEvent {
  final String query;

  fetchGetAllProduct(this.query);

  
}
