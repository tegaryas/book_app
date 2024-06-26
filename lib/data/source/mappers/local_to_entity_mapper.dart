import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/domain/entities/author.dart';
import 'package:book_app/domain/entities/book.dart';

extension BookHiveModelX on BookHiveModel {
  Book toEntity() => Book(
      id: id,
      title: title,
      authors: authors.map((e) => e.toEntity()).toList(),
      subject: subject,
      bookshelves: bookshelves,
      mediaType: mediaType,
      downloadCount: downloadCount);
}

extension AuthorHiveModelX on AuthorHiveModel {
  Author toEntity() => Author(name: name);
}
