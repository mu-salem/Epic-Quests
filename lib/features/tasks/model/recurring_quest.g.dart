// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringQuestAdapter extends TypeAdapter<RecurringQuest> {
  @override
  final int typeId = 6;

  @override
  RecurringQuest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringQuest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      priority: fields[3] as String,
      recurrenceType: fields[4] as RecurrenceType,
      customIntervalDays: fields[5] as int,
      createdAt: fields[6] as DateTime?,
      lastGeneratedAt: fields[7] as DateTime?,
      nextDueAt: fields[8] as DateTime,
      isActive: fields[9] as bool,
      heroId: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringQuest obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.recurrenceType)
      ..writeByte(5)
      ..write(obj.customIntervalDays)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastGeneratedAt)
      ..writeByte(8)
      ..write(obj.nextDueAt)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.heroId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringQuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 5;

  @override
  RecurrenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceType.daily;
      case 1:
        return RecurrenceType.weekly;
      case 2:
        return RecurrenceType.monthly;
      case 3:
        return RecurrenceType.custom;
      default:
        return RecurrenceType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceType obj) {
    switch (obj) {
      case RecurrenceType.daily:
        writer.writeByte(0);
        break;
      case RecurrenceType.weekly:
        writer.writeByte(1);
        break;
      case RecurrenceType.monthly:
        writer.writeByte(2);
        break;
      case RecurrenceType.custom:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
