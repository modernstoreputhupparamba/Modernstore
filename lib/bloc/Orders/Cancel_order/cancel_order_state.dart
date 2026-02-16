part of 'cancel_order_bloc.dart';

@immutable
abstract class CancelOrderState {}

class CancelOrderInitial extends CancelOrderState {}

class CancelOrderLoading extends CancelOrderState {}

class CancelOrderLoaded extends CancelOrderState {
  final CancelOrderModel cancelOrderModel;
  CancelOrderLoaded({required this.cancelOrderModel});
}

class CancelOrderError extends CancelOrderState {
  final String message;
  CancelOrderError({required this.message});
}