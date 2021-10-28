import 'package:flutter_photos/Models/photo_model.dart';
import 'package:flutter_photos/Repositories/repositories.dart';

abstract class BasePhotosRepository extends BaseRepository {
  Future<List<Photo>> searchPhotos({String query, int page});
}
