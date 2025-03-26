// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorModelAdapter extends TypeAdapter<DoctorModel> {
  @override
  final int typeId = 2;

  @override
  DoctorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorModel(
      name: fields[2] as String?,
      age: fields[3] as String?,
      phone: fields[4] as String?,
      qualification: fields[5] as String?,
      department: fields[6] as String?,
      years: fields[7] as String?,
      fees: fields[8] as String?,
      id: fields[0] as int?,
      imagePath: fields[1] as String?,
      status: fields[9] as String?,
      startTime: fields[10] as String?,
      endtime: fields[11] as String?,
      leaveDate: fields[12] as String?,
      endLeaveDate: fields[13] as String?,
      newFilePath: fields[14] as String?,
      titleName: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.qualification)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.years)
      ..writeByte(8)
      ..write(obj.fees)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.startTime)
      ..writeByte(11)
      ..write(obj.endtime)
      ..writeByte(12)
      ..write(obj.leaveDate)
      ..writeByte(13)
      ..write(obj.endLeaveDate)
      ..writeByte(14)
      ..write(obj.newFilePath)
      ..writeByte(15)
      ..write(obj.titleName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
