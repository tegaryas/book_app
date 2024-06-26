import 'dart:math';

import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDatasource {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter<BookHiveModel>(BookHiveModelAdapter());
    Hive.registerAdapter<AuthorHiveModel>(AuthorHiveModelAdapter());

    await Hive.openBox<BookHiveModel>(BookHiveModel.boxKey);
    await Hive.openBox<AuthorHiveModel>(AuthorHiveModel.boxKey);
  }

  Future<bool> hasData() async {
    final pokemonBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    return pokemonBox.length > 0;
  }

  Future<void> saveBooks(Iterable<BookHiveModel> books) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    final booksMap = {for (var e in books) e.id: e};

    await bookBox.clear();
    await bookBox.putAll(booksMap);
  }

  Future<List<BookHiveModel>> getAllBooks() async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    final books = List.generate(bookBox.length, (index) => bookBox.getAt(index))
        .whereType<BookHiveModel>()
        .toList();

    return books;
  }

  Future<List<BookHiveModel>> getBooks(
      {required int page, required int limit}) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);
    final totalBooks = bookBox.length;

    final start = (page - 1) * limit;
    final newPokemonCount = min(totalBooks - start, limit);

    final books =
        List.generate(newPokemonCount, (index) => bookBox.getAt(start + index))
            .whereType<BookHiveModel>()
            .toList();

    return books;
  }

  Future<BookHiveModel?> getBook(int id) async {
    final bookBox = Hive.box<BookHiveModel>(BookHiveModel.boxKey);

    return bookBox.get(id);
  }
}
