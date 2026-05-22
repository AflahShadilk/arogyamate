import 'package:hive_flutter/hive_flutter.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 4)
class NotificationModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? body;

  @HiveField(3)
  DateTime? dateTime;

  @HiveField(4)
  String? type; // 'appointment_booked', 'doctor_leave', 'appointment_cancelled'

  @HiveField(5)
  bool isRead;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.type,
    this.isRead = false,
  });
}
