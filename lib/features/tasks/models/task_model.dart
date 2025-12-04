import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String? id;

  @HiveField(4)
  DateTime updatedAt;

  Task({
    String? id,
    String? title,
    required this.dateTime,
    this.isCompleted = false,
    DateTime? updatedAt,
  }) : id = id ?? '',
       title = title ?? '',
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? '',
      'title': title ?? '',
      'time': dateTime
          .toIso8601String(), // Changed key to 'time' to match Supabase schema
      'is_completed': isCompleted, // Changed key to snake_case
      'updated_at': updatedAt.toIso8601String(), // Changed key to snake_case
      'user_id': Supabase.instance.client.auth.currentUser?.id,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      dateTime: DateTime.parse(map['time']),
      isCompleted: map['is_completed'] ?? false,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
