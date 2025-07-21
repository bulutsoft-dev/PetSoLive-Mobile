// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetDtoAdapter extends TypeAdapter<PetDto> {
  @override
  final int typeId = 0;

  @override
  PetDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetDto(
      id: fields[0] as int,
      name: fields[1] as String,
      species: fields[2] as String,
      breed: fields[3] as String,
      age: fields[4] as int,
      gender: fields[5] as String,
      weight: fields[6] as double,
      color: fields[7] as String,
      dateOfBirth: fields[8] as DateTime,
      description: fields[9] as String,
      vaccinationStatus: fields[10] as String,
      microchipId: fields[11] as String,
      isNeutered: fields[12] as bool?,
      imageUrl: fields[13] as String,
      ownerId: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PetDto obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.species)
      ..writeByte(3)
      ..write(obj.breed)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.vaccinationStatus)
      ..writeByte(11)
      ..write(obj.microchipId)
      ..writeByte(12)
      ..write(obj.isNeutered)
      ..writeByte(13)
      ..write(obj.imageUrl)
      ..writeByte(14)
      ..write(obj.ownerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
