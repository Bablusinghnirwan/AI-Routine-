import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 3)
class GoalModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime targetDate;

  @HiveField(4)
  String category;

  @HiveField(5)
  Map<String, dynamic> aiPlan; // Stores the full JSON plan from Gemini

  @HiveField(6)
  List<String> dailyTasks; // List of task IDs or simple strings

  @HiveField(7)
  double progressScore;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.category,
    this.aiPlan = const {},
    this.dailyTasks = const [],
    this.progressScore = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_date': targetDate.toIso8601String(), // snake_case
      'category': category,
      'ai_plan': aiPlan, // snake_case
      'daily_tasks': dailyTasks, // snake_case
      'progress_score': progressScore, // snake_case
      'created_at': createdAt.toIso8601String(), // snake_case
      'updated_at': updatedAt.toIso8601String(), // snake_case
      'user_id': Supabase.instance.client.auth.currentUser?.id,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetDate: DateTime.parse(map['target_date']),
      category: map['category'] ?? 'General',
      aiPlan: Map<String, dynamic>.from(map['ai_plan'] ?? {}),
      dailyTasks: List<String>.from(map['daily_tasks'] ?? []),
      progressScore: (map['progress_score'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
