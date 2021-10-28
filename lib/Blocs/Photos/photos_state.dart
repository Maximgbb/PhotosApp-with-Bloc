part of 'photos_bloc.dart';

enum PhotosStatus { initial, loading, loaded, paginating, noMorePhotos, error }

class PhotosState extends Equatable {
  final String query;
  final List<Photo> photos;
  final PhotosStatus status;
  final Failure failure;

  const PhotosState({
    @required this.query,
    @required this.photos,
    @required this.status,
    @required this.failure,
  });

  factory PhotosState.initial() {
    return const PhotosState(
      query: '',
      photos: [],
      status: PhotosStatus.initial,
      failure: null,
    );
  }

  @override
  List<Object> get props => [query, photos, status, failure];

  @override
  bool get stringify => true;

  /*This copyWith method allows us to build new states based on the current state since this class is
  inmutable (inmutable because of the final properties)*/
  PhotosState copyWith({
    String query,
    List<Photo> photos,
    PhotosStatus status,
    Failure failure,
  }) {
    return PhotosState(
      query: query ?? this.query,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
