import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppointmentRepository {
  static const String _boxName = 'appointmentDb';
  static Box<AppointModel>? _box;

  static Future<void> init() async {
    _box ??= await Hive.openBox<AppointModel>(_boxName);
  }

  static Box<AppointModel> get _db {
    if (_box == null || !_box!.isOpen) {
      throw StateError(
          'AppointmentRepository not initialised. Call AppointmentRepository.init() first.');
    }
    return _box!;
  }

  static Future<AppointModel> add(AppointModel model) async {
    final id = await _db.add(model);
    model.id = id;
    await _db.put(id, model);
    return model;
  }

  static List<AppointModel> getAll() => _db.values.toList();

  static Future<void> delete(int id) async {
    await _db.delete(id);
  }

  static Future<void> update(AppointModel model) async {
    assert(model.id != null, 'Cannot update an appointment without an id');
    await _db.put(model.id!, model);
  }

  static List<AppointModel> search(String query) {
    final q = query.toLowerCase();
    return _db.values
        .where((a) => (a.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  static List<AppointModel> filter({
    String? department,
    String? doctorName,
  }) {
    return _db.values.where((a) {
      final matchDept =
          department == null || (a.department ?? '') == department;
      final matchDoc =
          doctorName == null || (a.doctorName ?? '') == doctorName;
      return matchDept && matchDoc;
    }).toList();
  }

  static Map<String, List<String>> getFilterData() {
    final all = _db.values.toList();
    return {
      'departments': all.map((a) => a.department ?? '').toSet().where((s) => s.isNotEmpty).toList(),
      'doctors': all.map((a) => a.doctorName ?? '').toSet().where((s) => s.isNotEmpty).toList(),
      'blood': all.map((a) => a.blood ?? '').toSet().where((s) => s.isNotEmpty).toList(),
      'address': all.map((a) => a.address ?? '').toSet().where((s) => s.isNotEmpty).toList(),
    };
  }
}
