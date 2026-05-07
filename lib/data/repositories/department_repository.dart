import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DepartmentRepository {
  static const String _boxName = 'Department_db';
  static const String _doctorBoxName = 'DoctorsDb';
  static Box<DepartmentModel>? _box;

  static Future<void> init() async {
    _box ??= await Hive.openBox<DepartmentModel>(_boxName);
  }

  static Box<DepartmentModel> get _db {
    if (_box == null || !_box!.isOpen) {
      throw StateError(
          'DepartmentRepository not initialised. Call DepartmentRepository.init() first.');
    }
    return _box!;
  }

  static Future<DepartmentModel> add(DepartmentModel model) async {
    final id = await _db.add(model);
    model.id = id;
    await _db.put(id, model);
    return model;
  }

  static List<DepartmentModel> getAll() => _db.values.toList();

  static Future<bool> delete(int id, String departmentName) async {
    final doctorBox = Hive.isBoxOpen(_doctorBoxName)
        ? Hive.box<DoctorModel>(_doctorBoxName)
        : await Hive.openBox<DoctorModel>(_doctorBoxName);

    final hasDoctors =
        doctorBox.values.any((d) => d.department == departmentName);
    if (hasDoctors) return false;

    await _db.delete(id);
    return true;
  }

  static List<DepartmentModel> search(String query) {
    final q = query.toLowerCase();
    return _db.values
        .where((d) => d.department.toLowerCase().contains(q))
        .toList();
  }
}
