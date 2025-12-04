import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'summary_model.g.dart';

@HiveType(typeId: 1)
class SummaryModel extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String mood;

  @HiveField(2)
  String challenges;

  @HiveField(3)
  String proud;

  @HiveField(4)
  String aiSummary;

  @HiveField(5)
  double aiScore;

  @HiveField(6)
  String sentiment;

  @HiveField(7)
  String advice;

  @HiveField(8)
  String id;

  @HiveField(9)
  DateTime updatedAt;

  SummaryModel({
    required this.id,
    required this.date,
    required this.mood,
    required this.challenges,
    required this.proud,
    required this.aiSummary,
    required this.aiScore,
    required this.sentiment,
    required this.advice,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'challenges': challenges,
      'proud': proud,
      'ai_summary': aiSummary, // snake_case
      'ai_score': aiScore, // snake_case
      'sentiment': sentiment,
      'advice': advice,
      'updated_at': updatedAt.toIso8601String(), // snake_case
      'user_id': Supabase.instance.client.auth.currentUser?.id,
    };
  }

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    return SummaryModel(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      mood: map['mood'] ?? '',
      challenges: map['challenges'] ?? '',
      proud: map['proud'] ?? '',
      aiSummary: map['ai_summary'] ?? '',
      aiScore: (map['ai_score'] ?? 0).toDouble(),
      sentiment: map['sentiment'] ?? '',
      advice: map['advice'] ?? '',
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
