import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositery/model/Categories/edit_category_api.dart';

part 'edit_category_event.dart';
part 'edit_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  final EditCategoryApi editCategoryApi = EditCategoryApi();

  EditCategoryBloc() : super(EditCategoryInitial()) {
    on<SubmitEditCategory>((event, emit) async {
      emit(EditCategoryLoading());
      try {
        await editCategoryApi.updateCategory(
            categoryId: event.categoryId,
            categoryName: event.categoryName,
            imageFile: event.imageFile);
        emit(EditCategorySuccess());
      } catch (e) {
        emit(EditCategoryFailure(error: e.toString()));
      }
    });
  }
}
