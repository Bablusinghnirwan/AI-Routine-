// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressModelAdapter extends TypeAdapter<ProgressModel> {
  @override
  final int typeId = 4;

  @override
  ProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressModel(
      completedTasksInGoal: fields[0] as int,
      missedTasks: fields[1] as int,
      disciplineScore: fields[2] as double,
      consistencyRate: fields[3] as double,
      currentWeek: fields[4] as int,
      lastUpdated: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.completedTasksInGoal)
      ..writeByte(1)
      ..write(obj.missedTasks)
      ..writeByte(2)
      ..write(obj.disciplineScore)
      ..writeByte(3)
      ..write(obj.consistencyRate)
      ..writeByte(4)
      ..write(obj.currentWeek)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
