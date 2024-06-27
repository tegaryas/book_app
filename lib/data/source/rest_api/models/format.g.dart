// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestAPIFormatModel _$RestAPIFormatModelFromJson(Map<String, dynamic> json) =>
    RestAPIFormatModel(
      imageJpeg: json['image/jpeg'] as String? ?? '',
      textHtml: json['text/html'] as String? ?? '',
      textPlain: json['text/plain'] as String? ?? '',
    );

Map<String, dynamic> _$RestAPIFormatModelToJson(RestAPIFormatModel instance) =>
    <String, dynamic>{
      'image/jpeg': instance.imageJpeg,
      'text/html': instance.textHtml,
      'text/plain': instance.textPlain,
    };
