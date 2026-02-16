part of 'upload_image_bloc.dart';

@immutable
sealed class UploadImageEvent {}

class UploadImage extends UploadImageEvent {
  final File file;
  UploadImage({required this.file});
}