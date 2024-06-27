import 'package:book_app/data/source/rest_api/models/format.dart';
import 'package:json_annotation/json_annotation.dart';
import 'author.dart';

part 'book.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RestAPIBookModel {
  const RestAPIBookModel(
      {required this.id,
      required this.title,
      required this.authors,
      required this.subject,
      required this.bookshelves,
      required this.formats,
      required this.mediaType,
      required this.downloadCount});

  factory RestAPIBookModel.fromJson(Map<String, dynamic> json) =>
      _$RestAPIBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestAPIBookModelToJson(this);

  final int id;

  final String title;

  @JsonKey(defaultValue: [])
  final List<RestAPIAuthorModel> authors;

  @JsonKey(defaultValue: [])
  final List<String> subject;

  @JsonKey(defaultValue: [])
  final List<String> bookshelves;

  final RestAPIFormatModel formats;

  final String mediaType;

  final int downloadCount;
}
