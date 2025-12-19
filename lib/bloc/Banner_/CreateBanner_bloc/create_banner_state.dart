part of 'create_banner_bloc.dart';

@immutable
abstract class CreateBannerState {}

class CreateBannerInitial extends CreateBannerState {}

class CreateBannerLoading extends CreateBannerState {}

class CreateBannerLoaded extends CreateBannerState {
  final CreateBannerModel result;
  CreateBannerLoaded({required this.result});
}

class CreateBannerError extends CreateBannerState {
  final String message;
  CreateBannerError({required this.message});
}

