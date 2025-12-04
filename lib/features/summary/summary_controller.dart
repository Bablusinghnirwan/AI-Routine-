import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:my_routine/features/summary/summary_model.dart';
import 'package:my_routine/services/ai_service.dart';
import 'package:my_routine/services/cloud_sync_service.dart';

class SummaryController extends ChangeNotifier {
  final AIService _aiService = AIService();
  final CloudSyncService _syncService = CloudSyncService();
  final Uuid _uuid = const Uuid();
  Box<SummaryModel>? _summaryBox;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> init() async {
    _summaryBox = await Hive.openBox<SummaryModel>('summaries');
    notifyListeners();
  }

  Future<void> generateAndSaveSummary({
    required String mood,
    required String challenges,
    required String proud,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final aiResponse = await _aiService.generateDailyFeedback(
        mood: mood,
        challenges: challenges,
        proud: proud,
      );

      // Parse AI response (Basic parsing logic, assuming AI follows format)
      // In a real app, we'd want more robust JSON parsing or structured output.
      // For now, we'll store the raw text and some dummy/parsed values if possible.
      // The prompt asks for specific fields, but returns a string.
      // We will store the full response in aiSummary.

      // Simple heuristic parsing for score/sentiment if possible, else defaults.
      double score = 0.0;
      String sentiment = 'Neutral';
      String advice = '';

      // Very basic parsing attempt
      final lines = aiResponse.split('\n');
      for (var line in lines) {
        if (line.toLowerCase().contains('score')) {
          final match = RegExp(r'(\d+)').firstMatch(line);
          if (match != null) {
            score = double.tryParse(match.group(0) ?? '0') ?? 0.0;
          }
        }
        if (line.toLowerCase().contains('sentiment')) {
          if (line.toLowerCase().contains('positive')) {
            sentiment = 'Positive';
          } else if (line.toLowerCase().contains('negative')) {
            sentiment = 'Negative';
          }
        }
        if (line.toLowerCase().contains('advice')) {
          advice = line
              .replaceAll(RegExp(r'advice:', caseSensitive: false), '')
              .trim();
        }
      }

      final summary = SummaryModel(
        id: _uuid.v4(),
        date: DateTime.now(),
        mood: mood,
        challenges: challenges,
        proud: proud,
        aiSummary: aiResponse,
        aiScore: score,
        sentiment: sentiment,
        advice: advice,
        updatedAt: DateTime.now(),
      );

      await _summaryBox?.add(summary);
      await _syncService.syncSummary(summary);
    } catch (e) {
      debugPrint("Error saving summary: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SummaryModel> getRecentSummaries() {
    if (_summaryBox == null) return [];
    return _summaryBox!.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double getWeeklyAverageScore() {
    final summaries = getRecentSummaries();
    if (summaries.isEmpty) return 0.0;

    final recent7 = summaries.take(7);
    double total = 0;
    for (var s in recent7) {
      total += s.aiScore;
    }
    return total / recent7.length;
  }
}
