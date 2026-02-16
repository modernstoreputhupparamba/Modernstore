import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:meta/meta.dart';


import '../../../repositery/api/User/edit_user_profile_api.dart';
import '../../../repositery/model/user/edit_user_profile_model.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditUserProfileApi api = EditUserProfileApi();

  EditProfileBloc() : super(EditProfileInitial()) {
    on<UpdateProfileEvent>((event, emit) async {
      emit(EditProfileLoading());
      try {
        final response = await api.updateProfile(event.userData, imageFile: event.imageFile);
        emit(EditProfileSuccess(model: response));
      } catch (e) {
        emit(EditProfileFailure(error: e.toString()));
      }
    });
  }
}