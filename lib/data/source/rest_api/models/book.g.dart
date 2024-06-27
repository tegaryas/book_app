// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestAPIBookModel _$RestAPIBookModelFromJson(Map<String, dynamic> json) =>
    RestAPIBookModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)
              ?.map(
                  (e) => RestAPIAuthorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subject: (json['subject'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      bookshelves: (json['bookshelves'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      formats:
          RestAPIFormatModel.fromJson(json['formats'] as Map<String, dynamic>),
      mediaType: json['media_type'] as String,
      downloadCount: (json['download_count'] as num).toInt(),
    );

Map<String, dynamic> _$RestAPIBookModelToJson(RestAPIBookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'subject': instance.subject,
      'bookshelves': instance.bookshelves,
      'formats': instance.formats,
      'media_type': instance.mediaType,
      'download_count': instance.downloadCount,
    };
