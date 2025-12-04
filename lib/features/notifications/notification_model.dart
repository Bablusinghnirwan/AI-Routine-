import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 6) // Ensure unique typeId
enum NotificationType {
  @HiveField(0)
  reminder,
  @HiveField(1)
  achievement,
  @HiveField(2)
  ai,
  @HiveField(3)
  update,
}

@HiveType(typeId: 7) // Ensure unique typeId
class AppNotification extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final NotificationType type;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final String? actionLabel;

  @HiveField(7)
  final String? actionPayload; // JSON string or simple ID

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.timestamp,
    this.actionLabel,
    this.actionPayload,
  });
}
