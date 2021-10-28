import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photos/Models/models.dart';
import 'package:flutter_photos/Screens/screens.dart';

//Single photo card element for the photos result screen's grid
class PhotoCard extends StatelessWidget {
  final List<Photo> photos;
  final int index;
  final Photo photo;

  const PhotoCard({Key key, @required this.photo, this.photos, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PhotoViewerScreen(
            photos: photos,
            currentIndex: index,
          ),
        ),
      ),
      child: Hero(
        tag: Key('${index}_${photo.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 4.0,
              ),
            ],
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  photo.url,
                ),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
