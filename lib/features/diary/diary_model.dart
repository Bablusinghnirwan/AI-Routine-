import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'diary_model.g.dart';

@HiveType(typeId: 2)
class DiaryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String rawText;

  @HiveField(3)
  String aiSummary;

  @HiveField(4)
  double aiScore;

  @HiveField(5)
  String sentiment;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  String mood;

  @HiveField(8)
  int color;

  DiaryModel({
    required this.id,
    required this.date,
    required this.rawText,
    this.aiSummary = '',
    this.aiScore = 0.0,
    this.sentiment = '',
    this.mood = '😊',
    this.color = 0xFF11002F, // Default deep purple
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'raw_text': rawText,
      'ai_summary': aiSummary,
      'ai_score': aiScore,
      'sentiment': sentiment,
      'mood': mood,
      'color': color,
      'updated_at': updatedAt.toIso8601String(),
      'user_id': Supabase.instance.client.auth.currentUser?.id,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      rawText: map['raw_text'] ?? '',
      aiSummary: map['ai_summary'] ?? '',
      aiScore: (map['ai_score'] ?? 0).toDouble(),
      sentiment: map['sentiment'] ?? '',
      mood: map['mood'] ?? '😊',
      color: map['color'] ?? 0xFF11002F,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
