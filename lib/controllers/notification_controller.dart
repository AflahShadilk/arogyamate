import 'dart:async';
import 'package:arogyamate/data/repositories/notification_repository.dart';
import 'package:arogyamate/data_base/models/notification_model.dart';
import 'package:flutter/foundation.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // In-app Toast Banner state
  String? _toastTitle;
  String? _toastMessage;
  String? _toastType;
  bool _showToast = false;
  Timer? _toastTimer;

  String? get toastTitle => _toastTitle;
  String? get toastMessage => _toastMessage;
  String? get toastType => _toastType;
  bool get showToast => _showToast;

  Future<void> loadAll() async {
    _notifications = NotificationRepository.getAll();
    notifyListeners();
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required String type,
  }) async {
    final newNotification = NotificationModel(
      title: title,
      body: body,
      dateTime: DateTime.now(),
      type: type,
      isRead: false,
    );
    await NotificationRepository.add(newNotification);
    await loadAll();

    // Trigger in-app toast notification
    _triggerToast(title, body, type);
  }

  void _triggerToast(String title, String body, String type) {
    _toastTimer?.cancel();
    _toastTitle = title;
    _toastMessage = body;
    _toastType = type;
    _showToast = true;
    notifyListeners();

    _toastTimer = Timer(const Duration(seconds: 4), () {
      _showToast = false;
      notifyListeners();
    });
  }

  Future<void> markAsRead(int id) async {
    await NotificationRepository.markAsRead(id);
    await loadAll();
  }

  Future<void> markAllAsRead() async {
    await NotificationRepository.markAllAsRead();
    await loadAll();
  }

  Future<void> deleteNotification(int id) async {
    await NotificationRepository.delete(id);
    await loadAll();
  }

  Future<void> clearAll() async {
    await NotificationRepository.clearAll();
    await loadAll();
  }

  void dismissToast() {
    _toastTimer?.cancel();
    _showToast = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }
}
