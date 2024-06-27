import 'package:json_annotation/json_annotation.dart';

part 'format.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RestAPIFormatModel {
  const RestAPIFormatModel({
    required this.imageJpeg,
    required this.textHtml,
    required this.textPlain,
  });

  factory RestAPIFormatModel.fromJson(Map<String, dynamic> json) =>
      _$RestAPIFormatModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestAPIFormatModelToJson(this);

  @JsonKey(name: "image/jpeg", defaultValue: "")
  final String imageJpeg;

  @JsonKey(name: "text/html", defaultValue: "")
  final String textHtml;

  @JsonKey(name: "text/plain", defaultValue: "")
  final String textPlain;
}
