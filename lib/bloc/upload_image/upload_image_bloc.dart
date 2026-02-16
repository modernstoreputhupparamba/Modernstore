import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:modern_grocery/repositery/api/Image_upload/upload_image_api.dart';
import 'package:modern_grocery/repositery/model/Image_upload/upload_image_model.dart';


part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  final UploadImageApi api = UploadImageApi();

  UploadImageBloc() : super(UploadImageInitial()) {
    on<UploadImage>((event, emit) async {
      emit(UploadImageLoading());
      try {
        final response = await api.uploadImage(event.file);
        emit(UploadImageSuccess(model: response));
      } catch (e) {
        emit(UploadImageFailure(error: e.toString()));
      }
    });
  }
}