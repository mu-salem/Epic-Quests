// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 1;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      deadline: fields[3] as DateTime?,
      priority: fields[4] as QuestPriority,
      isCompleted: fields[5] as bool,
      completedAt: fields[6] as DateTime?,
      createdAt: fields[7] as DateTime?,
      pomodorosCompleted: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.deadline)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.pomodorosCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestPriorityAdapter extends TypeAdapter<QuestPriority> {
  @override
  final int typeId = 2;

  @override
  QuestPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestPriority.low;
      case 1:
        return QuestPriority.medium;
      case 2:
        return QuestPriority.high;
      default:
        return QuestPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, QuestPriority obj) {
    switch (obj) {
      case QuestPriority.low:
        writer.writeByte(0);
        break;
      case QuestPriority.medium:
        writer.writeByte(1);
        break;
      case QuestPriority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
