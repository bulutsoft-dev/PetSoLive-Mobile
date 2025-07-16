// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_pet_ad_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LostPetAdDtoAdapter extends TypeAdapter<LostPetAdDto> {
  @override
  final int typeId = 1;

  @override
  LostPetAdDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LostPetAdDto(
      id: fields[0] as int,
      petName: fields[1] as String,
      description: fields[2] as String,
      lastSeenDate: fields[3] as DateTime,
      imageUrl: fields[4] as String,
      userId: fields[5] as int,
      lastSeenCity: fields[6] as String,
      lastSeenDistrict: fields[7] as String,
      createdAt: fields[8] as DateTime,
      userName: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LostPetAdDto obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.lastSeenDate)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.lastSeenCity)
      ..writeByte(7)
      ..write(obj.lastSeenDistrict)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.userName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LostPetAdDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
