part of 'send_otp_bloc.dart';

@immutable
abstract class SendOtpEvent {}

class SendOtpRequested extends SendOtpEvent {
  final String phoneNumber;
  SendOtpRequested({required this.phoneNumber});
}