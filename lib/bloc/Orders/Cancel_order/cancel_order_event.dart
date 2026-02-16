part of 'cancel_order_bloc.dart';

@immutable
abstract class CancelOrderEvent {}

class CancelOrder extends CancelOrderEvent {
  final String orderId;
  final String reason;

  CancelOrder({required this.orderId, required this.reason});
}