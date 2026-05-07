import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DoctorRepository {
  static const String _boxName = 'DoctorsDb';
  static Box<DoctorModel>? _box;

  static Future<void> init() async {
    _box ??= await Hive.openBox<DoctorModel>(_boxName);
  }

  static Box<DoctorModel> get _db {
    if (_box == null || !_box!.isOpen) {
      throw StateError(
          'DoctorRepository not initialised. Call DoctorRepository.init() first.');
    }
    return _box!;
  }

  static Future<DoctorModel> add(DoctorModel model) async {
    final id = await _db.add(model);
    model.id = id;
    await _db.put(id, model);
    return model;
  }

  static List<DoctorModel> getAll() => _db.values.toList();

  static Future<void> delete(int id) async {
    await _db.delete(id);
  }

  static Future<void> update(DoctorModel model) async {
    assert(model.id != null, 'Cannot update a doctor without an id');
    await _db.put(model.id!, model);
  }

  static List<DoctorModel> searchByName(String query) {
    final q = query.toLowerCase();
    return _db.values
        .where((d) => (d.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  static List<DoctorModel> searchByDepartment(String query) {
    final q = query.toLowerCase();
    return _db.values
        .where((d) => (d.department ?? '').toLowerCase().contains(q))
        .toList();
  }

  static Future<void> setShift(
    DoctorModel model, {
    required String? status,
    required String? startTime,
    required String? endTime,
  }) async {
    assert(model.id != null, 'Doctor id must not be null');
    model.status = status;
    model.startTime = startTime;
    model.endtime = endTime;
    await _db.put(model.id!, model);
  }

  static Future<void> setStatus(
    DoctorModel model, {
    required String status,
    String? startTime,
    String? endTime,
    String? leaveDate,
    String? endLeaveDate,
  }) async {
    assert(model.id != null, 'Doctor id must not be null');
    model.status = status;
    model.startTime = startTime;
    model.endtime = endTime;
    model.leaveDate = leaveDate;
    model.endLeaveDate = endLeaveDate;
    await _db.put(model.id!, model);
  }

  static Future<void> saveFilePath(DoctorModel model, String filePath) async {
    assert(model.id != null, 'Doctor id must not be null');
    model.newFilePath = filePath;
    await _db.put(model.id!, model);
  }

  static Map<String, List> getFilterData() {
    final all = _db.values.toList();
    return {
      'departments': all
          .map((d) => d.department ?? '')
          .toSet()
          .where((s) => s.isNotEmpty)
          .toList(),
      'qualifications': all
          .map((d) => d.qualification ?? '')
          .toSet()
          .where((s) => s.isNotEmpty)
          .toList(),
      'ages': all
          .map((d) => int.tryParse(d.years ?? ''))
          .whereType<int>()
          .toSet()
          .toList(),
      'fees': all
          .map((d) => double.tryParse(d.fees ?? ''))
          .whereType<double>()
          .toSet()
          .toList(),
    };
  }
}
