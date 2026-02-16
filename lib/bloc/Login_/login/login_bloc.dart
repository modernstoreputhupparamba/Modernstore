import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:modern_grocery/repositery/api/login/login_api.dart';
import 'package:modern_grocery/repositery/model/login_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Loginapi loginapi = Loginapi();
  late Loginmodel login;

  LoginBloc() : super(LoginInitial()) {
    on<fetchlogin>((event, emit) async {
      emit(loginBlocLoading());
              print('Bloc  Loading successfully ..............');

      try {
        login = await loginapi.getLogin(phoneNumber: event.phoneNumber!);

        emit(loginBlocLoaded(login: login));
        print('Bloc Loaded successfully ..............');
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(loginBlocError());
      }
    });
  }
}
