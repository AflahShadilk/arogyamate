
import 'package:hive_flutter/hive_flutter.dart';
part 'appointment_model.g.dart';
@HiveType(typeId: 3)
class AppointModel extends HiveObject{
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? age;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  String? blood;
  @HiveField(5)
  String? address;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? doctorName;
  @HiveField(8)
  String? date;
  @HiveField(9)
  String? time;
  @HiveField(10)
  String ?filePath;
  @HiveField(11)
  String ?title;
  AppointModel(
      {this.id,
      required this.name,
      required this.age,
      required this.phone,
      required this.blood,
      required this.address,
      required this.department,
      required this.doctorName,
      required this.date,
      required this.time,
      this.filePath,
      this.title});
}
