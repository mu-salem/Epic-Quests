// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeroProfileAdapter extends TypeAdapter<HeroProfile> {
  @override
  final int typeId = 0;

  @override
  HeroProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeroProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarAsset: fields[2] as String,
      gender: fields[3] as String,
      level: fields[4] as int,
      currentXP: fields[5] as int,
      quests: (fields[6] as List).cast<Quest>(),
      currentStreak: fields[7] as int,
      longestStreak: fields[8] as int,
      totalCompletedQuests: fields[9] as int,
      createdAt: fields[10] as DateTime?,
      lastActivityDate: fields[11] as DateTime?,
      recurringQuests: (fields[12] as List).cast<RecurringQuest>(),
    );
  }

  @override
  void write(BinaryWriter writer, HeroProfile obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatarAsset)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.currentXP)
      ..writeByte(6)
      ..write(obj.quests)
      ..writeByte(7)
      ..write(obj.currentStreak)
      ..writeByte(8)
      ..write(obj.longestStreak)
      ..writeByte(9)
      ..write(obj.totalCompletedQuests)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.lastActivityDate)
      ..writeByte(12)
      ..write(obj.recurringQuests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
