// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SummaryModelAdapter extends TypeAdapter<SummaryModel> {
  @override
  final int typeId = 1;

  @override
  SummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SummaryModel(
      id: fields[8] as String,
      date: fields[0] as DateTime,
      mood: fields[1] as String,
      challenges: fields[2] as String,
      proud: fields[3] as String,
      aiSummary: fields[4] as String,
      aiScore: fields[5] as double,
      sentiment: fields[6] as String,
      advice: fields[7] as String,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SummaryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.challenges)
      ..writeByte(3)
      ..write(obj.proud)
      ..writeByte(4)
      ..write(obj.aiSummary)
      ..writeByte(5)
      ..write(obj.aiScore)
      ..writeByte(6)
      ..write(obj.sentiment)
      ..writeByte(7)
      ..write(obj.advice)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
