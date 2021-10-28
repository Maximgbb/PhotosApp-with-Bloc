import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/Blocs/blocs.dart';
import 'package:flutter_photos/Widgets/widgets.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key key}) : super(key: key);

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            context.read<PhotosBloc>().state.status !=
                PhotosStatus.paginating) {
          context.read<PhotosBloc>().add(PhotosPaginate());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //This is for hidding the keyboard when pressing anywhere in the screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photos'),
        ),
        body: BlocConsumer<PhotosBloc, PhotosState>(
          listener: (context, state) {
            if (state.status == PhotosStatus.paginating) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Loading more photos...'),
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(seconds: 1),
                ),
              );
            } else if (state.status == PhotosStatus.noMorePhotos) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No more photos.'),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 1500),
                ),
              );
            } else if (state.status == PhotosStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search error'),
                  content: Text(state.failure.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          context
                              .read<PhotosBloc>()
                              .add(PhotosSearchPhotos(query: val.trim()));
                        }
                      },
                    ),
                    Expanded(
                      child: state.photos.isNotEmpty
                          ? GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(20.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 15.0,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: state.photos.length,
                              itemBuilder: (context, index) {
                                final photo = state.photos[index];
                                return PhotoCard(
                                  photo: photo,
                                  photos: state.photos,
                                  index: index,
                                );
                              },
                            )
                          : const Center(child: Text('No results.')),
                    ),
                  ],
                ),
                if (state.status == PhotosStatus.loading)
                  const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
