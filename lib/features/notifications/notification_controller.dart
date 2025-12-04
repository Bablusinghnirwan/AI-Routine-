import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'notification_model.dart';

class NotificationController extends ChangeNotifier {
  static const String _boxName = 'notifications';
  Box<AppNotification>? _box;

  List<AppNotification> get notifications {
    if (_box == null) return [];
    final list = _box!.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    return list;
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(NotificationTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(AppNotificationAdapter());
    }
    _box = await Hive.openBox<AppNotification>(_boxName);
    notifyListeners();
  }

  Future<void> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? actionLabel,
    String? actionPayload,
  }) async {
    final notification = AppNotification(
      id: const Uuid().v4(),
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
      actionLabel: actionLabel,
      actionPayload: actionPayload,
    );
    await _box?.add(notification);
    notifyListeners();
  }

  Future<void> markAsRead(AppNotification notification) async {
    notification.isRead = true;
    await notification.save();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    for (var n in notifications) {
      if (!n.isRead) {
        n.isRead = true;
        await n.save();
      }
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _box?.clear();
    notifyListeners();
  }

  Future<void> deleteNotification(AppNotification notification) async {
    await notification.delete();
    notifyListeners();
  }
}
