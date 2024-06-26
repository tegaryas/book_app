import 'package:book_app/domain/entities/author.dart';

class Book {
  const Book(
      {required this.id,
      required this.title,
      required this.authors,
      required this.subject,
      required this.bookshelves,
      required this.mediaType,
      required this.downloadCount});

  final int id;
  final String title;
  final List<Author> authors;
  final List<String> subject;
  final List<String> bookshelves;
  final String mediaType;
  final int downloadCount;
}
