import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_photos/Models/failure_model.dart';
import 'package:flutter_photos/Models/models.dart';
import 'package:flutter_photos/Repositories/repositories.dart';
part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository _photosRepository;

  PhotosBloc({@required PhotosRepository photosRepository})
      : _photosRepository = photosRepository,
        super(PhotosState.initial()) {
    on<PhotosSearchPhotos>(_onPhotosSearchPhotos);
    on<PhotosPaginate>(_onPhotosPaginate);
  }

  @override
  Future<void> close() {
    _photosRepository.dispose();
    return super.close();
  }

  void _onPhotosSearchPhotos(
      PhotosSearchPhotos event, Emitter<PhotosState> emit) async {
    emit(state.copyWith(query: event.query, status: PhotosStatus.loading));
    try {
      final photos = await _photosRepository.searchPhotos(query: event.query);
      emit(state.copyWith(photos: photos, status: PhotosStatus.loaded));
    } catch (err) {
      // ignore: avoid_print
      print(err);
      emit(
        state.copyWith(
          failure: const Failure(
              message: 'Soemthing went wrong! Please try a different search.'),
          status: PhotosStatus.error,
        ),
      );
    }
  }

  void _onPhotosPaginate(
      PhotosPaginate event, Emitter<PhotosState> emit) async {
    emit(
      state.copyWith(status: PhotosStatus.paginating),
    );

    /*The reason we do .from is to create a copy of our state. We don't want 
    to modify our original photos list. If we modify state.photos directly, 
    emitting a new state will not rebuild the UI because our bloc is constantly 
    listening for differences in states.*/
    final photos = List<Photo>.from(state.photos);
    List<Photo> nextPhotos = [];

    if (photos.length >= PhotosRepository.numPerPage) {
      nextPhotos = await _photosRepository.searchPhotos(
          query: state.query,
          page: state.photos.length ~/ PhotosRepository.numPerPage + 1);
    }

    emit(
      state.copyWith(
        photos: photos..addAll(nextPhotos),
        status: nextPhotos.isNotEmpty
            ? PhotosStatus.loaded
            : PhotosStatus.noMorePhotos,
      ),
    );
  }
}
