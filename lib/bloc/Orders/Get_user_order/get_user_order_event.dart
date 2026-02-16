part of 'get_user_order_bloc.dart';

@immutable
sealed class GetUserOrderEvent {}
class FetchGetUserOrders extends GetUserOrderEvent {}