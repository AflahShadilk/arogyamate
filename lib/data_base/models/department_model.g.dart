// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentModelAdapter extends TypeAdapter<DepartmentModel> {
  @override
  final int typeId = 1;

  @override
  DepartmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepartmentModel(
      id: fields[0] as int?,
      department: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DepartmentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.department);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
