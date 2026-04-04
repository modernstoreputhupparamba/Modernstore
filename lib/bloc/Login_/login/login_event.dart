part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class fetchlogin extends LoginEvent {
  final String? phoneNumber;
  final String? otp;
 

  fetchlogin({required this.phoneNumber, required this.otp});
}
