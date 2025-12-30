// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 1;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      mosqueName: fields[0] as String,
      location: fields[1] as String,
      mobileNumber: fields[2] as String,
      description: fields[3] as String,
      date: fields[4] as DateTime,
      prayerType: fields[5] as PrayerType,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mosqueName)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.mobileNumber)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.prayerType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrayerTypeAdapter extends TypeAdapter<PrayerType> {
  @override
  final int typeId = 0;

  @override
  PrayerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrayerType.dhuhr;
      case 1:
        return PrayerType.asr;
      case 2:
        return PrayerType.isha;
      default:
        return PrayerType.dhuhr;
    }
  }

  @override
  void write(BinaryWriter writer, PrayerType obj) {
    switch (obj) {
      case PrayerType.dhuhr:
        writer.writeByte(0);
        break;
      case PrayerType.asr:
        writer.writeByte(1);
        break;
      case PrayerType.isha:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
