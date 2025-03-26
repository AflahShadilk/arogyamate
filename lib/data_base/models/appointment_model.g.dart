// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointModelAdapter extends TypeAdapter<AppointModel> {
  @override
  final int typeId = 3;

  @override
  AppointModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      age: fields[2] as String?,
      phone: fields[3] as String?,
      blood: fields[4] as String?,
      address: fields[5] as String?,
      department: fields[6] as String?,
      doctorName: fields[7] as String?,
      date: fields[8] as String?,
      time: fields[9] as String?,
      filePath: fields[10] as String?,
      title: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.blood)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.doctorName)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.time)
      ..writeByte(10)
      ..write(obj.filePath)
      ..writeByte(11)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
