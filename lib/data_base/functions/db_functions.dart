// ignore_for_file: invalid_use_of_protected_member



import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<DepartmentModel>> departmentListNotify = ValueNotifier([]);

Future<void> addDepartment(DepartmentModel value) async {
  final departMentDb = await Hive.openBox<DepartmentModel>('Department_db');
  int id = await departMentDb.add(value);
  value.id = id;
  await departMentDb.put(id, value);
  departmentListNotify.notifyListeners();
  await getAllDepartment();
}

Future<void> getAllDepartment() async {
  final departMentDb = await Hive.openBox<DepartmentModel>('Department_db');
  departmentListNotify.value.clear();
  departmentListNotify.value.addAll(departMentDb.values);
  departmentListNotify.notifyListeners();
}



Future<bool> deleteDepartment(int id,String department) async {
  
  final doctorDb = await Hive.openBox<DoctorModel>('DoctorsDb');

  final departMentDb = await Hive.openBox<DepartmentModel>('Department_db');
  if(doctorDb.values.any((doctor)=>doctor.department==department)){
   
    return false; 
  }
  await departMentDb.delete(id);
  await getAllDepartment();
  return true;
}

Future<void> searchDepartment(String query) async {
  final departMentDb = await Hive.openBox<DepartmentModel>('Department_db');
  List<DepartmentModel> result = departMentDb.values
      .where(
          (item) => item.department.toLowerCase().contains(query.toLowerCase()))
      .toList();
  departmentListNotify.value.clear();

  departmentListNotify.value.addAll(result);
  departmentListNotify.notifyListeners();
}
