import 'dart:math';

import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/data/source/local/models/format.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDataSource {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter<BookHiveModel>(BookHiveModelAdapter());
    Hive.registerAdapter<AuthorHiveModel>(AuthorHiveModelAdapter());
    Hive.registerAdapter<FormatHiveModel>(FormatHiveModelAdapter());

    await Hive.openBox<BookHiveModel>(BookHiveModel.boxKey);
    await Hive.openBox<AuthorHiveModel>(AuthorHiveModel.boxKey);
    await Hive.openBox<FormatHiveModel>(FormatHiveModel.boxKey);
    await Hive.openBox<BookHiveModel>(BookHiveModel.favoriteBoxKey);
  }

  Future<bool> hasData() async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    return bookBox.length > 0;
  }

  Future<void> saveBooks(Iterable<BookHiveModel> books) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    final booksMap = {for (var e in books) e.id: e};

    await bookBox.putAll(booksMap);
  }

  Future<List<BookHiveModel>> getAllBooks() async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    final books = List.generate(bookBox.length, (index) => bookBox.getAt(index))
        .whereType<BookHiveModel>()
        .toList();

    return books;
  }

  Future<List<BookHiveModel>> getBooks({
    required int page,
    required int limit,
    String query = "",
  }) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);
    final totalBooks = bookBox.length;

    final start = (page - 1) * limit;
    final newBooksCount = min(totalBooks - start, limit);

    final books = List.generate(
            newBooksCount, (index) => bookBox.getAt(start + index))
        .whereType<BookHiveModel>()
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return books;
  }

  Future<BookHiveModel?> getBook(int id) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    return bookBox.get(id);
  }

  Future<List<BookHiveModel>> getFavoriteBooks({
    required int page,
    required int limit,
  }) async {
    final favoriteBooksBox =
        Hive.box<BookHiveModel>(BookHiveModel.favoriteBoxKey);
    final totalBooks = favoriteBooksBox.length;

    final start = (page - 1) * limit;
    final newBooksCount = min(totalBooks - start, limit);

    final books = List.generate(
            newBooksCount, (index) => favoriteBooksBox.getAt(start + index))
        .whereType<BookHiveModel>()
        .toList();

    return books;
  }

  Future<void> saveFavoriteBook(BookHiveModel book) async {
    final favoriteBooksBox =
        Hive.box<BookHiveModel>(BookHiveModel.favoriteBoxKey);
    await favoriteBooksBox.put(book.id, book);
  }

  Future<void> removeFavoriteBook(BookHiveModel book) async {
    final favoriteBooksBox =
        Hive.box<BookHiveModel>(BookHiveModel.favoriteBoxKey);
    await favoriteBooksBox.delete(book.id);
  }

  Future<BookHiveModel?> getFavoriteBook(BookHiveModel book) async {
    final favoriteBooksBox =
        Hive.box<BookHiveModel>(BookHiveModel.favoriteBoxKey);
    return favoriteBooksBox.get(book.id);
  }
}
