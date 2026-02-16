part of 'edit_category_bloc.dart';

@immutable
sealed class EditCategoryEvent {}

class SubmitEditCategory extends EditCategoryEvent {
  final String categoryId;
  final String categoryName;
  final File? imageFile; // Image is optional during an update

  SubmitEditCategory({
    required this.categoryId,
    required this.categoryName,
    this.imageFile,
  });
}