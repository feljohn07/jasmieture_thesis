// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      firstname: fields[0] as String,
      lastname: fields[1] as String,
      middlename: fields[2] as String,
      section: fields[3] as String,
      age: fields[4] as int,
      pin: fields[5] as String,
      bgm: fields[6] as bool,
      sfx: fields[7] as bool,
      volume: fields[8] as double,
      language: fields[9] as String,
      bgmPathIndex: fields[10] as int,
      unlockedLevels: (fields[11] as List?)?.cast<int>(),
      unlockedChapters: (fields[12] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.middlename)
      ..writeByte(3)
      ..write(obj.section)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.pin)
      ..writeByte(6)
      ..write(obj.bgm)
      ..writeByte(7)
      ..write(obj.sfx)
      ..writeByte(8)
      ..write(obj.volume)
      ..writeByte(9)
      ..write(obj.language)
      ..writeByte(10)
      ..write(obj.bgmPathIndex)
      ..writeByte(11)
      ..write(obj.unlockedLevels)
      ..writeByte(12)
      ..write(obj.unlockedChapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
