part of 'edit_category_bloc.dart';

@immutable
sealed class EditCategoryState {}

final class EditCategoryInitial extends EditCategoryState {}

final class EditCategoryLoading extends EditCategoryState {}

final class EditCategorySuccess extends EditCategoryState {}

final class EditCategoryFailure extends EditCategoryState {
  final String error;
  EditCategoryFailure({required this.error});
}