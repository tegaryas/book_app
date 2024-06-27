// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormatHiveModelAdapter extends TypeAdapter<FormatHiveModel> {
  @override
  final int typeId = 3;

  @override
  FormatHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormatHiveModel()
      ..imageJpeg = fields[0] as String
      ..textHtml = fields[1] as String
      ..textPlain = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, FormatHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imageJpeg)
      ..writeByte(1)
      ..write(obj.textHtml)
      ..writeByte(2)
      ..write(obj.textPlain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormatHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
