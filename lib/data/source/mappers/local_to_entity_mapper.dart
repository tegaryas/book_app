import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/data/source/local/models/format.dart';
import 'package:book_app/domain/entities/author.dart';
import 'package:book_app/domain/entities/book.dart';
import 'package:book_app/domain/entities/format.dart';

extension BookHiveModelX on BookHiveModel {
  Book toEntity() => Book(
      id: id,
      title: title,
      authors: authors.map((e) => e.toEntity()).toList(),
      subject: subject,
      bookshelves: bookshelves,
      formats: formats.toEntity(),
      mediaType: mediaType,
      downloadCount: downloadCount);
}

extension AuthorHiveModelX on AuthorHiveModel {
  Author toEntity() => Author(name: name);
}

extension FormatHiveModelX on FormatHiveModel {
  Format toEntity() =>
      Format(imageJpeg: imageJpeg, textHtml: textHtml, textPlain: textPlain);
}
