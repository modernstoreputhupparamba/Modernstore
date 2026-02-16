part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class UpdateProfileEvent extends EditProfileEvent {
  final Map<String, dynamic> userData;
  final File? imageFile;

  UpdateProfileEvent({required this.userData, this.imageFile});
}