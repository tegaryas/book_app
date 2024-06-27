import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/data/source/local/models/format.dart';
import 'package:book_app/domain/entities/book.dart';

extension BookModelToLocalX on Book {
  BookHiveModel toHiveModel() => BookHiveModel()
    ..id = id.toInt()
    ..title = title.trim()
    ..authors =
        (authors.map((e) => (AuthorHiveModel()..name = e.name.trim())).toList())
    ..subject = subject
    ..bookshelves = bookshelves
    ..formats = (FormatHiveModel()
      ..imageJpeg = formats.imageJpeg.trim()
      ..textHtml = formats.textHtml.trim()
      ..textPlain = formats.textPlain.trim())
    ..mediaType = mediaType.trim()
    ..downloadCount = downloadCount.toInt();
}
