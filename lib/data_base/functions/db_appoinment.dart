import 'dart:async';

import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<AppointModel>> AppointmentNotifier = ValueNotifier([]);

Future<void> addAppoinment(AppointModel value) async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');
  int id = await appoinmentDb.add(value);
  value.id = id;
  await appoinmentDb.put(id, value);
  // ignore: invalid_use_of_protected_member
  AppointmentNotifier.notifyListeners();
  await getAllAppoinments();
}

Future getAllAppoinments() async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');
  AppointmentNotifier.value.clear();
  AppointmentNotifier.value.addAll(appoinmentDb.values);
  // ignore: invalid_use_of_protected_member
  AppointmentNotifier.notifyListeners();
}

Future<void> deleteAppoinment(int? id) async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');
  await appoinmentDb.delete(id);
  await getAllAppoinments();
}

Future<void> updateAppoinment(AppointModel value) async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');
  await appoinmentDb.put(value.id, value);
  await getAllAppoinments();
}

Future<void> searchAppoinment(String query) async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');
  List<AppointModel> res = appoinmentDb.values
      .where((patient) =>
          (patient.name ?? '').toLowerCase().contains(query.toLowerCase()))
      .toList();
  AppointmentNotifier.value.clear();
  AppointmentNotifier.value.addAll(res);
  // ignore: invalid_use_of_protected_member
  AppointmentNotifier.notifyListeners;
}

//--filter
Future<void> fetchFilterAppoinment() async {
  final appoinmentDb = await Hive.openBox<AppointModel>('appoimnentDb');

  List<AppointModel> patient = appoinmentDb.values.toList();

  // ignore: unused_local_variable
  List<String> departments =
      patient.map((d) => d.department ?? '').toSet().toList();
  // ignore: unused_local_variable
  List<String> doctor = patient.map((d) => d.doctorName ?? '').toSet().toList();

  // ignore: unused_local_variable
  List<String> blood = patient.map((d) => d.blood ?? '').toSet().toList();

  // ignore: unused_local_variable
  List<String> address = patient.map((d) => d.address ?? '').toSet().toList();

  // ignore: invalid_use_of_protected_member
  AppointmentNotifier.notifyListeners();
}
