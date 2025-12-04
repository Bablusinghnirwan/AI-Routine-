import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'progress_model.g.dart';

@HiveType(typeId: 4)
class ProgressModel extends HiveObject {
  @HiveField(0)
  int completedTasksInGoal;

  @HiveField(1)
  int missedTasks;

  @HiveField(2)
  double disciplineScore;

  @HiveField(3)
  double consistencyRate;

  @HiveField(4)
  int currentWeek;

  @HiveField(5)
  DateTime lastUpdated;

  ProgressModel({
    this.completedTasksInGoal = 0,
    this.missedTasks = 0,
    this.disciplineScore = 0.0,
    this.consistencyRate = 0.0,
    this.currentWeek = 1,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'completed_tasks_in_goal': completedTasksInGoal, // snake_case
      'missed_tasks': missedTasks, // snake_case
      'discipline_score': disciplineScore, // snake_case
      'consistency_rate': consistencyRate, // snake_case
      'current_week': currentWeek, // snake_case
      'last_updated': lastUpdated.toIso8601String(), // snake_case
      'user_id': Supabase.instance.client.auth.currentUser?.id,
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      completedTasksInGoal: map['completed_tasks_in_goal'] ?? 0,
      missedTasks: map['missed_tasks'] ?? 0,
      disciplineScore: (map['discipline_score'] ?? 0.0).toDouble(),
      consistencyRate: (map['consistency_rate'] ?? 0.0).toDouble(),
      currentWeek: map['current_week'] ?? 1,
      lastUpdated: DateTime.parse(map['last_updated']),
    );
  }
}
