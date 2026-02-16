part of 'get_all_banner_bloc.dart';

@immutable
sealed class GetAllBannerState {}

final class GetAllBannerInitial extends GetAllBannerState {}

final class GetAllBannerLoading extends GetAllBannerState {}

final class GetAllBannerLoaded extends GetAllBannerState {
  final GetAllBannerModel banner;

  GetAllBannerLoaded({required this.banner});
}


final class GetAllBannerError extends GetAllBannerState {
  final String errorMessage;
  
  GetAllBannerError({required this.errorMessage});
}