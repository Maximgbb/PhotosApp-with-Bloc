import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_photos/Models/models.dart';

class Photo extends Equatable {
  final String id;
  final String description;
  final String url;
  final User user;

  const Photo(
      {@required this.id,
      @required this.description,
      @required this.url,
      @required this.user});

  factory Photo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Photo(
        id: map['id'],
        description: map['description'] ?? 'No description.',
        url: map['urls']['regular'],
        user: User.fromMap(map['user']));
  }

  @override
  List<Object> get props => [id, description, url, user];

  @override
  bool get stringify => true;
}
