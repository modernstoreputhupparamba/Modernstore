import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/login/send_otp_api.dart';


import 'package:modern_grocery/repositery/model/send_otp_model.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final SendOtpApi api = SendOtpApi();

  SendOtpBloc() : super(SendOtpInitial()) {
    on<SendOtpRequested>((event, emit) async {
      emit(SendOtpLoading());
      try {
        final response = await api.sendOtp(event.phoneNumber);
        emit(SendOtpSuccess(model: response));
      } catch (e) {
        emit(SendOtpFailure(error: e.toString()));
      }
    });
  }
}