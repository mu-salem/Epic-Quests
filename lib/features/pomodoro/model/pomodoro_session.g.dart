// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PomodoroSessionAdapter extends TypeAdapter<PomodoroSession> {
  @override
  final int typeId = 7;

  @override
  PomodoroSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PomodoroSession(
      id: fields[0] as String,
      questId: fields[1] as String?,
      heroId: fields[2] as String,
      startedAt: fields[3] as DateTime,
      endedAt: fields[4] as DateTime,
      workDurationMinutes: fields[5] as int,
      wasCompleted: fields[6] as bool,
      xpAwarded: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PomodoroSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questId)
      ..writeByte(2)
      ..write(obj.heroId)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.endedAt)
      ..writeByte(5)
      ..write(obj.workDurationMinutes)
      ..writeByte(6)
      ..write(obj.wasCompleted)
      ..writeByte(7)
      ..write(obj.xpAwarded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
