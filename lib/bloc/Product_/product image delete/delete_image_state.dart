part of 'delete_image_bloc.dart';

@immutable
sealed class DeleteImageState {}

final class DeleteImageInitial extends DeleteImageState {}

final class DeleteImageLoading extends DeleteImageState {}

final class DeleteImageLoaded extends DeleteImageState {
  final DeleteImageModel deleteImageModel;
  DeleteImageLoaded({required this.deleteImageModel});
}

final class DeleteImageError extends DeleteImageState {
  final String message;
  DeleteImageError({required this.message});
}