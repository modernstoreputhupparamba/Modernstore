// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:modern_grocery/bloc/Login_/verify/verify_event.dart';
// import 'package:modern_grocery/repositery/api/login/login_api.dart';
// import 'package:modern_grocery/repositery/model/login_model.dart';

// part 'verify_state.dart';

// class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
//   Loginapi loginapi = Loginapi();
//   late Loginmodel login;

//   VerifyBloc() : super(VerifyInitial()) {
//     on<fetchVerifyOTPEvent>((event, emit) async {
//       emit(VerifyLoading());
//       try {
//         login = await loginapi.verifyOTP(
//             phoneNumber: event.phoneNumber, otp: event.otp);
//         emit(VerifySuccess(login: login));
//       } catch (e) {
//         emit(VerifyError(message: e.toString()));
//       }
//     });

//     on<ResendOTPRequested>((event, emit) async {
//       emit(VerifyLoading());

//       try {
//         await loginapi.getLogin(phoneNumber: event.phoneNumber);

//         emit(OTPResent());

//         emit(VerifyInitial());
//       } catch (e) {
//         emit(VerifyError(message: 'Failed to resend OTP'));
//       }
//     });
//   }
// }
