part of 'create_order_bloc.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrderButtonPressed extends CreateOrderEvent {

  final String shippingAddress;
  final String paymentMethod;
  final int deliveryCharge;

  const CreateOrderButtonPressed(
      {
      required this.shippingAddress,
      required this.paymentMethod,
      required this.deliveryCharge});
}