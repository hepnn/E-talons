// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etalons.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EtalonsAdapter extends TypeAdapter<Etalons> {
  @override
  final int typeId = 0;

  @override
  Etalons read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Etalons(
      id: fields[0] as String,
      firstBusNumber: fields[1] as String,
      secondBusNumber: fields[2] as String,
      firstBusType: fields[3] as String,
      secondBusType: fields[4] as String,
      firstRideTime: fields[5] as String,
      secondRideTime: fields[6] as String,
      getTotalTrips: fields[7] as String,
      getRemainingTrips: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Etalons obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstBusNumber)
      ..writeByte(2)
      ..write(obj.secondBusNumber)
      ..writeByte(3)
      ..write(obj.firstBusType)
      ..writeByte(4)
      ..write(obj.secondBusType)
      ..writeByte(5)
      ..write(obj.firstRideTime)
      ..writeByte(6)
      ..write(obj.secondRideTime)
      ..writeByte(7)
      ..write(obj.getTotalTrips)
      ..writeByte(8)
      ..write(obj.getRemainingTrips)
      ..writeByte(9)
      ..write(obj.timeScanned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EtalonsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
