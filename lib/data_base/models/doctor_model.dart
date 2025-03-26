import 'package:hive_flutter/hive_flutter.dart';
  part 'doctor_model.g.dart';
@HiveType(typeId: 2)
class DoctorModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? imagePath;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? age;
  @HiveField(4)
  String? phone;
  @HiveField(5)
  String? qualification;
  @HiveField(6)
  String? department;
  @HiveField(7)
  String? years;
  @HiveField(8)
  String? fees;
  @HiveField(9)
  String? status;
  @HiveField(10)
  String? startTime;
  @HiveField(11)
  String? endtime;
  @HiveField(12)
  String? leaveDate;
  @HiveField(13)
  String? endLeaveDate;
  @HiveField(14)
  String? newFilePath;
  @HiveField(15)
  String ?titleName;

  DoctorModel(
      {required this.name,
      required this.age,
      required this.phone,
      required this.qualification,
      required this.department,
      required this.years,
      required this.fees,
      this.id,
      required this.imagePath,
      this.status,
      this.startTime,
      this.endtime,
      this.leaveDate,
      this.endLeaveDate,
      this.newFilePath,
      this.titleName
      });
}
