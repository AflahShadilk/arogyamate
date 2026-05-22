import 'package:arogyamate/data_base/models/notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationRepository {
  static const String _boxName = 'notificationDb';
  static Box<NotificationModel>? _box;

  static Future<void> init() async {
    _box ??= await Hive.openBox<NotificationModel>(_boxName);
  }

  static Box<NotificationModel> get _db {
    if (_box == null || !_box!.isOpen) {
      throw StateError(
          'NotificationRepository not initialised. Call NotificationRepository.init() first.');
    }
    return _box!;
  }

  static Future<NotificationModel> add(NotificationModel model) async {
    final id = await _db.add(model);
    model.id = id;
    await _db.put(id, model);
    return model;
  }

  static List<NotificationModel> getAll() {
    final list = _db.values.toList();
    // Sort by dateTime descending (newest first)
    list.sort((a, b) => (b.dateTime ?? DateTime.now()).compareTo(a.dateTime ?? DateTime.now()));
    return list;
  }

  static Future<void> delete(int id) async {
    await _db.delete(id);
  }

  static Future<void> markAsRead(int id) async {
    final model = _db.get(id);
    if (model != null) {
      model.isRead = true;
      await _db.put(id, model);
    }
  }

  static Future<void> markAllAsRead() async {
    for (var model in _db.values) {
      if (!model.isRead) {
        model.isRead = true;
        await _db.put(model.id, model);
      }
    }
  }

  static Future<void> clearAll() async {
    await _db.clear();
  }
}
