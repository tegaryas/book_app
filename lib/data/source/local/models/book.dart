import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class BookHiveModel extends HiveObject {
  static const String boxKey = "book";

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String authors;

  @HiveField(3)
  late List<String> subject;

  @HiveField(4)
  late List<String> bookshelves;

  @HiveField(5)
  late String mediaType;

  @HiveField(6)
  late int downloadCount;
}
