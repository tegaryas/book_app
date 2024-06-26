import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RestAPIAuthorModel {
  const RestAPIAuthorModel({required this.name});

  factory RestAPIAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$RestAPIAuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestAPIAuthorModelToJson(this);

  final String name;
}
