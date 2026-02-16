part of 'userprofile_bloc.dart';

@immutable
sealed class UserprofileState {}

final class UserprofileInitial extends UserprofileState {}

final class Userprofileloading extends UserprofileState {}

final class Userprofileloaded extends UserprofileState {
  final GetUserProfile user;
  Userprofileloaded({required this.user});
}

final class UserprofileError extends UserprofileState {}
