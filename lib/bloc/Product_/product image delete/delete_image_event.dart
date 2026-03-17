part of 'delete_image_bloc.dart';

@immutable
sealed class DeleteImageEvent {}

class FetchDeleteImage extends DeleteImageEvent {
  final String productId;
  final String imageUrl;

  FetchDeleteImage({required this.productId, required this.imageUrl});
}