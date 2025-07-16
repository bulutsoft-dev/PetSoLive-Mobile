// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_request_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HelpRequestStatusAdapter extends TypeAdapter<HelpRequestStatus> {
  @override
  final int typeId = 11;

  @override
  HelpRequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HelpRequestStatus.Active;
      case 1:
        return HelpRequestStatus.Passive;
      default:
        return HelpRequestStatus.Active;
    }
  }

  @override
  void write(BinaryWriter writer, HelpRequestStatus obj) {
    switch (obj) {
      case HelpRequestStatus.Active:
        writer.writeByte(0);
        break;
      case HelpRequestStatus.Passive:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelpRequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
