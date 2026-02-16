part of 'get_all_orders_bloc.dart';

@immutable
abstract class GetAllOrdersState {}

class GetAllOrdersInitial extends GetAllOrdersState {}

class GetAllOrdersLoading extends GetAllOrdersState {}

class GetAllOrdersLoaded extends GetAllOrdersState {
  final GetAllOrdersModel getAllOrdersModel;
  GetAllOrdersLoaded({required this.getAllOrdersModel});
}

class GetAllOrdersError extends GetAllOrdersState {
  final String message;
  GetAllOrdersError({required this.message});
}