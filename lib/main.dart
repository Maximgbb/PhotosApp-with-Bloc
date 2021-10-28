import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/Screens/screens.dart';
import 'Blocs/blocs.dart';
import 'Repositories/repositories.dart';

void main() {
  //This is for whenever we print out objects that uses props, we get the equatable stringify option
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhotosRepository(),
      child: BlocProvider(
        create: (context) => PhotosBloc(
          photosRepository: context.read<PhotosRepository>(),
        )..add(const PhotosSearchPhotos(query: 'dogs')),
        child: MaterialApp(
          title: 'Flutter Photos App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const PhotosScreen(),
        ),
      ),
    );
  }
}
