part of 'upload_image_bloc.dart';

@immutable
sealed class UploadImageState {}

final class UploadImageInitial extends UploadImageState {}

final class UploadImageLoading extends UploadImageState {}

final class UploadImageSuccess extends UploadImageState {
  final UploadImageModel model;
  UploadImageSuccess({required this.model});
}

final class UploadImageFailure extends UploadImageState {
  final String error;
  UploadImageFailure({required this.error});
}