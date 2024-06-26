import 'package:book_app/app.dart';
import 'package:book_app/core/network.dart';
import 'package:book_app/data/repositories/book_repository.dart';
import 'package:book_app/data/source/local/local_datasource.dart';
import 'package:book_app/data/source/rest_api/rest_api_datasource.dart';
import 'package:book_app/states/book/book_bloc.dart';
import 'package:book_app/states/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDataSource.initialize();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<NetworkManager>(
        create: (context) => NetworkManager(),
      ),
      RepositoryProvider<LocalDataSource>(
        create: (context) => LocalDataSource(),
      ),
      RepositoryProvider<RestApiDatasource>(
        create: (context) =>
            RestApiDatasource(networkManager: context.read<NetworkManager>()),
      ),
      RepositoryProvider<BookRepository>(
        create: (context) => BookDefaultRepository(
          localDataSource: context.read<LocalDataSource>(),
          restApiDatasource: context.read<RestApiDatasource>(),
        ),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<BookBloc>(
          create: (context) => BookBloc(context.read<BookRepository>()),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        )
      ],
      child: const BookApp(),
    ),
  ));
}
