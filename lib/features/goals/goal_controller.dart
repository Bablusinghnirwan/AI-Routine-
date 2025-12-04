import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../services/gemini_service.dart';
import '../../services/cloud_sync_service.dart';
import 'goal_model.dart';

class GoalController extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final CloudSyncService _cloudSyncService = CloudSyncService();

  Box<GoalModel>? _goalBox;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GoalModel> get goals => _goalBox?.values.toList() ?? [];

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(GoalModelAdapter());
    }
    _goalBox = await Hive.openBox<GoalModel>('goals');
    notifyListeners();
  }

  Future<void> createGoal(
    String title,
    String description,
    DateTime targetDate,
    String category,
  ) async {
    _setLoading(true);
    try {
      final newGoal = GoalModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        targetDate: targetDate,
        category: category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Generate AI Plan
      final plan = await _geminiService.generateGoalPlan(newGoal);
      newGoal.aiPlan = plan;

      // Extract daily tasks if available
      if (plan.containsKey('daily_plan')) {
        // Logic to extract task IDs or content could go here
        // For now, we store the plan structure
      }

      await _goalBox?.put(newGoal.id, newGoal);
      await _cloudSyncService.syncGoalToCloud(newGoal);

      notifyListeners();
    } catch (e) {
      print('Error creating goal: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    goal.updatedAt = DateTime.now();
    await goal.save();
    await _cloudSyncService.syncGoalToCloud(goal);
    notifyListeners();
  }

  Future<void> deleteGoal(String id) async {
    await _goalBox?.delete(id);
    await _cloudSyncService.deleteGoal(id);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
