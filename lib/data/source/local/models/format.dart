import 'package:hive/hive.dart';

part 'format.g.dart';

@HiveType(typeId: 3)
class FormatHiveModel extends HiveObject {
  static const String boxKey = "bookFormat";

  @HiveField(0)
  late String imageJpeg;

  @HiveField(1)
  late String textHtml;

  @HiveField(2)
  late String textPlain;
}
