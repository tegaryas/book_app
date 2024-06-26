import 'package:book_app/data/source/local/local_datasource.dart';
import 'package:book_app/data/source/mappers/local_to_entity_mapper.dart';
import 'package:book_app/data/source/mappers/restapi_to_local_mapper.dart';
import 'package:book_app/data/source/rest_api/rest_api_datasource.dart';
import 'package:book_app/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getAllBooks();

  Future<List<Book>> getBooks({required int limit, required int page});

  Future<Book?> getBook(int id);
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
      final bookRestModels = await restApiDatasource.getPokemons();
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
  Future<List<Book>> getBooks({required int limit, required int page}) async {
    final hasCachedData = await localDataSource.hasData();

    if (!hasCachedData) {
      final bookRestModels = await restApiDatasource.getPokemons();
      final bookHiveModels = bookRestModels.map((e) => e.toHiveModel());

      await localDataSource.saveBooks(bookHiveModels);
    }

    final bookHiveModels = await localDataSource.getBooks(
      page: page,
      limit: limit,
    );

    final bookEntities = bookHiveModels.map((e) => e.toEntity()).toList();

    return bookEntities;
  }
}
