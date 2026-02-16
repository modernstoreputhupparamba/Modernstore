part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final EditUserProfileModel model;

  EditProfileSuccess({required this.model});
}

class EditProfileFailure extends EditProfileState {
  final String error;

  EditProfileFailure({required this.error});
}