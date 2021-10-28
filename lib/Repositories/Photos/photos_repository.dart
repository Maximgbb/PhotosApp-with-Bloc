import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_photos/Models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_photos/Models/photo_model.dart';
import 'package:flutter_photos/Repositories/repositories.dart';
import 'package:flutter_photos/.env.dart';

class PhotosRepository extends BasePhotosRepository {
  static const String _unsplashBaseURL = 'https://api.unsplash.com';
  static const int numPerPage = 20;

  //We create a http client to talk to the API
  final http.Client _httpClient;

  //We initialize _httpClient in the constructor, if it's not passed in
  PhotosRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  //Here we close the http client when we're done using it
  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<List<Photo>> searchPhotos({
    @required String query,
    int page = 1,
  }) async {
    //Here we construct our url
    final url = Uri.parse(
        '$_unsplashBaseURL/search/photos?client_id=$unsplashAPIKey&page=$page&per_page=$numPerPage&query=$query');

    //We get a response back from the get request
    final response = await _httpClient.get(url);

    //If our response was successfull (i.e. == 200)
    if (response.statusCode == 200) {
      //We first convert our response body which is a String, into a Map
      final Map<String, dynamic> data = jsonDecode(response.body);

      //Then we get the results list from our data
      final List results = data['results'];

      //And we iterate over that result list, mapping each one into a Photo element, and then we convert  that map into a List.
      final List<Photo> photos = results.map((e) => Photo.fromMap(e)).toList();

      return photos;
    }
    throw const Failure();
  }
}
