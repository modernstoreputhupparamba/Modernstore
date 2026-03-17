import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../repositery/api/product/delete_image_api.dart';
import '../../../repositery/model/product/delete_image_model.dart';

part 'delete_image_event.dart';
part 'delete_image_state.dart';

class DeleteImageBloc extends Bloc<DeleteImageEvent, DeleteImageState> {
  final DeleteImageApi deleteImageApi = DeleteImageApi();

  DeleteImageBloc() : super(DeleteImageInitial()) {
    on<FetchDeleteImage>((event, emit) async {
      emit(DeleteImageLoading());
      try {
        final model = await deleteImageApi.deleteImage(
          productId: event.productId,
          imageUrl: event.imageUrl,
        );
        emit(DeleteImageLoaded(deleteImageModel: model));
      } catch (e) {
        emit(DeleteImageError(message: e.toString()));
      }
    });
  }
}