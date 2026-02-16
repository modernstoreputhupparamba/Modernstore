part of 'get_user_order_bloc.dart';

abstract class GetUserOrderState {
  const GetUserOrderState();

  @override
  List<Object> get props => [];
}

class GetUserOrderInitial extends GetUserOrderState {}

class GetUserOrderLoading extends GetUserOrderState {}

class GetUserOrderLoaded extends GetUserOrderState {
  final GetUserOrderModel getUserOrderModel;

  const GetUserOrderLoaded({required this.getUserOrderModel});

  @override
  List<Object> get props => [getUserOrderModel];
}

class GetUserOrderError extends GetUserOrderState {
  final String message;

  const GetUserOrderError({required this.message});

  @override
  List<Object> get props => [message];
}
