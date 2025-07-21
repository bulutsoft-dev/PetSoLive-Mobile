// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_request_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelpRequestDtoAdapter extends TypeAdapter<HelpRequestDto> {
  @override
  final int typeId = 2;

  @override
  HelpRequestDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HelpRequestDto(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      emergencyLevel: fields[3] as EmergencyLevel,
      createdAt: fields[4] as DateTime,
      userId: fields[5] as int,
      userName: fields[6] as String,
      location: fields[7] as String,
      contactName: fields[8] as String?,
      contactPhone: fields[9] as String?,
      contactEmail: fields[10] as String?,
      imageUrl: fields[11] as String?,
      status: fields[12] as HelpRequestStatus,
    );
  }

  @override
  void write(BinaryWriter writer, HelpRequestDto obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.emergencyLevel)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.userName)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.contactName)
      ..writeByte(9)
      ..write(obj.contactPhone)
      ..writeByte(10)
      ..write(obj.contactEmail)
      ..writeByte(11)
      ..write(obj.imageUrl)
      ..writeByte(12)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelpRequestDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
