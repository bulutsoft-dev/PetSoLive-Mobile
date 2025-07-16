// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmergencyLevelAdapter extends TypeAdapter<EmergencyLevel> {
  @override
  final int typeId = 10;

  @override
  EmergencyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EmergencyLevel.low;
      case 1:
        return EmergencyLevel.medium;
      case 2:
        return EmergencyLevel.high;
      default:
        return EmergencyLevel.low;
    }
  }

  @override
  void write(BinaryWriter writer, EmergencyLevel obj) {
    switch (obj) {
      case EmergencyLevel.low:
        writer.writeByte(0);
        break;
      case EmergencyLevel.medium:
        writer.writeByte(1);
        break;
      case EmergencyLevel.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
