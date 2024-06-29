import 'package:book_app/data/source/local/models/author.dart';
import 'package:book_app/data/source/local/models/format.dart';
import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class BookHiveModel extends HiveObject {
  static const String boxKey = "book";
  static const String favoriteBoxKey = "favoriteBook";

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late List<AuthorHiveModel> authors;

  @HiveField(3)
  late List<String> subject;

  @HiveField(4)
  late List<String> bookshelves;

  @HiveField(5)
  late FormatHiveModel formats;

  @HiveField(6)
  late String mediaType;

  @HiveField(7)
  late int downloadCount;
}
