import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/book.dart';
import 'package:book_app/data/source/rest_api/models/book.dart';

extension RestAPIBookModelToLocalX on RestAPIBookModel {
  BookHiveModel toHiveModel() => BookHiveModel()
    ..id = id.toInt()
    ..title = title.trim()
    ..authors =
        (authors.map((e) => (AuthorHiveModel()..name = e.name.trim())).toList())
    ..subject = subject
    ..bookshelves = bookshelves
    ..mediaType = mediaType.trim()
    ..downloadCount = downloadCount.toInt();
}
