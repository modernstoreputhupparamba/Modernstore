part of 'userdeliveryaddress_bloc.dart';

@immutable
sealed class UserdeliveryaddressState {
  const UserdeliveryaddressState();

  @override
  List<Object?> get props => [];
}

final class UserdeliveryaddressInitial extends UserdeliveryaddressState {
  const UserdeliveryaddressInitial();
}

final class UserdeliveryaddressLoading extends UserdeliveryaddressState {
  const UserdeliveryaddressLoading();
}

final class UserdeliveryaddressLoaded extends UserdeliveryaddressState {
  final GetUserDlvAddresses addresses; // ✅ strongly typedaddresses; // ✅ strongly typed

  const UserdeliveryaddressLoaded(this.addresses);


}

final class UserdeliveryaddressError extends UserdeliveryaddressState {
  final String message;

  const UserdeliveryaddressError(this.message);

}