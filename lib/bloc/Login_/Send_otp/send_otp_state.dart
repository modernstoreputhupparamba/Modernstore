part of 'send_otp_bloc.dart';

@immutable
abstract class SendOtpState {}

class SendOtpInitial extends SendOtpState {}

class SendOtpLoading extends SendOtpState {}

class SendOtpSuccess extends SendOtpState {
  final SendOtpModel model;
  SendOtpSuccess({required this.model});
}

class SendOtpFailure extends SendOtpState {
  final String error;
  SendOtpFailure({required this.error});
}