import 'dart:developer';

import 'package:book_app/data/source/local/local_datasource.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/data/source/mappers/entity_to_local_mapper.dart';
import 'package:book_app/data/source/mappers/local_to_entity_mapper.dart';
import 'package:book_app/data/source/mappers/restapi_to_local_mapper.dart';
import 'package:book_app/data/source/rest_api/rest_api_datasource.dart';
import 'package:book_app/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAllBooks();

  Future<(List<Book>, bool)> getBooks({
    required int limit,
    required int page,
    String query = "",
    bool isOnline = false,
  });

  Future<Book?> getBook(int id);

  Future<List<Book>> getFavoriteBooks({required int limit, required int page});

  Future<void> saveFavoriteBook(Book book);

  Future<void> removeFavoriteBook(Book book);

  Future<Book?> getFavoriteBook(Book book);
}

class BookDefaultRepository extends BookRepository {
  final RestApiDatasource restApiDatasource;
  final LocalDataSource localDataSource;

  BookDefaultRepository(
      {required this.restApiDatasource, required this.localDataSource});

  @override
  Future<List<Book>> getAllBooks() async {
    final hasCachedData = await localDataSource.hasData();

    if (!hasCachedData) {
      final (bookRestModels, _) = await restApiDatasource.getBooks();
      final bookHiveModels = bookRestModels.map((e) => e.toHiveModel());

      await localDataSource.saveBooks(bookHiveModels);
    }

    final bookHiveModels = await localDataSource.getAllBooks();

    final bookEntities = bookHiveModels.map((e) => e.toEntity()).toList();

    return bookEntities;
  }

  @override
  Future<Book?> getBook(int id) async {
    final bookModel = await localDataSource.getBook(id);

    if (bookModel == null) return null;

    final book = bookModel.toEntity();

    return book;
  }

  @override
  Future<(List<Book>, bool)> getBooks({
    required int limit,
    required int page,
    String query = "",
    bool isOnline = false,
  }) async {
    bool canLoadMore = false;
    List<BookHiveModel> bookHiveModels = [];

    if (isOnline) {
      final (bookRestModels, nextNotNull) =
          await restApiDatasource.getBooks(page: page);
      canLoadMore = nextNotNull;

      bookHiveModels = bookRestModels.map((e) => e.toHiveModel()).toList();

      log("${bookRestModels.map((e) => e.toJson()).toList()}");
      await localDataSource.saveBooks(bookHiveModels);
    } else {
      bookHiveModels = await localDataSource.getBooks(
          page: page, limit: limit, query: query);
    }
    final bookEntities = bookHiveModels.map((e) => e.toEntity()).toList();

    return (bookEntities, canLoadMore);
  }

  @override
  Future<List<Book>> getFavoriteBooks(
      {required int limit, required int page}) async {
    final bookHiveModels =
        await localDataSource.getFavoriteBooks(page: page, limit: limit);

    final bookEntities = bookHiveModels.map((e) => e.toEntity()).toList();

    return bookEntities;
  }

  @override
  Future<void> saveFavoriteBook(Book book) async {
    await localDataSource.saveFavoriteBook(book.toHiveModel());
  }

  @override
  Future<Book?> getFavoriteBook(Book book) async {
    final bookHiveModel =
        await localDataSource.getFavoriteBook(book.toHiveModel());
    return bookHiveModel?.toEntity();
  }

  @override
  Future<void> removeFavoriteBook(Book book) async {
    await localDataSource.removeFavoriteBook(book.toHiveModel());
  }
}
