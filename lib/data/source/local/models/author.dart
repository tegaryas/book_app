import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 2)
class AuthorHiveModel extends HiveObject {
  static const String boxKey = "bookAuthor";

  @HiveField(0)
  late String name;
}
