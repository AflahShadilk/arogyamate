import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<DoctorModel>> doctorNotifier = ValueNotifier([]);

Future<void> addDoctors(DoctorModel value) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  int id = await doctorDb.add(value);
  value.id = id;
  await doctorDb.put(id, value);
  // ignore: invalid_use_of_protected_member
  doctorNotifier.notifyListeners();
  await getAllDoctors();
}

Future<void> getAllDoctors() async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  doctorNotifier.value.clear();
  doctorNotifier.value.addAll(doctorDb.values);
  // ignore: invalid_use_of_protected_member
  doctorNotifier.notifyListeners();
}

Future<void> searchDoctor(String query) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  List<DoctorModel> result = doctorDb.values
      .where((doctor) =>
          (doctor.name ?? '').toLowerCase().contains(query.toLowerCase()))
      .toList();

  doctorNotifier.value.clear();
  doctorNotifier.value.addAll(result);
  // ignore: invalid_use_of_protected_member
  doctorNotifier.notifyListeners();
}

Future<void> searchDoctorDipartment(String query) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  List<DoctorModel> result = doctorDb.values
      .where((doctor) =>
          (doctor.department ?? '').toLowerCase().contains(query.toLowerCase()))
      .toList();

  doctorNotifier.value.clear();
  doctorNotifier.value.addAll(result);
  // ignore: invalid_use_of_protected_member
  doctorNotifier.notifyListeners();
}

Future<void> deleteDoctor(int id) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  await doctorDb.delete(id);
  await getAllDoctors();
}

Future<void> updateDoctor(DoctorModel doctor) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');

  if (doctor.id == null) {
    throw HiveError('Doctor ID cannot be null');
  }

  await doctorDb.put(doctor.id!, doctor);
  await getAllDoctors();
}

Future<void> settingDoctorShift(int id, DoctorModel value, String? status,
    String? startTime, String? endtime) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  value.status = status;
  value.startTime = startTime;
  value.endtime = endtime;
  await doctorDb.put(id, value);
  await getAllDoctors();
}

Future<void> settingDoctorStatus(int id, DoctorModel value, String status,
    {String? stattTime, String? endTime, String? date, String? endDate}) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  value.status = status;
  value.startTime = stattTime;
  value.endtime = endTime;
  value.leaveDate = date;
  value.endLeaveDate = endDate;

  await doctorDb.put(id, value);
  await getAllDoctors();
}

Future<String> getFilesOfDoctor(
    int id, DoctorModel value, String newFilePath) async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  value.newFilePath = newFilePath;

  await doctorDb.put(id, value);

  return newFilePath;
}

Future<void> fetchFilterData() async {
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');
  List<DoctorModel> doctors = doctorDb.values.toList();

  // ignore: unused_local_variable
  List<String> departments =
      doctors.map((d) => d.department ?? '').toSet().toList();
  // ignore: unused_local_variable
  List<String> qualifications =
      doctors.map((d) => d.qualification ?? '').toSet().toList();

  // ignore: unused_local_variable
  List<int> ages = doctors
      .map((d) => int.tryParse(d.years ?? '') ?? 0)
      .where((a) => a > 0)
      .toSet()
      .toList();

  // ignore: unused_local_variable
  List<double> fees = doctors
      .map((d) => double.tryParse(d.fees ?? '') ?? 0.0)
      .where((f) => f > 0.0)
      .toSet()
      .toList();

  // ignore: invalid_use_of_protected_member
  doctorNotifier.notifyListeners();
}
