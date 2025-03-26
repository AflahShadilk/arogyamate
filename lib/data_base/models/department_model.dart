





import 'package:hive_flutter/hive_flutter.dart';
  part 'department_model.g.dart';
@HiveType(typeId:1)
class DepartmentModel{
  @HiveField(0)
 int? id;
 @HiveField(1)
 final String department;

  DepartmentModel({this.id, required this.department});
 
}