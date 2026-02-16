part of 'create_banner_bloc.dart';

@immutable
abstract class CreateBannerEvent {}

class FetchCreateBannerEvent extends CreateBannerEvent {
  final String title;
  final String category;
  final String type;
  final String? categoryId;
  final String? productId;
  final String link;
  final File imagePath; // 👈 actually a File, not a path
  final void Function(int sent, int total)? onSendProgress;

  FetchCreateBannerEvent({
    required this.title,
    required this.category,
    required this.type,
     this.categoryId,
    this.productId,
    required this.link,
    required this.imagePath,
    this.onSendProgress,
  });
}
