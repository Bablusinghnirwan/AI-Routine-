import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'progress_model.dart';
import '../../services/cloud_sync_service.dart';

class ProgressController extends ChangeNotifier {
  final CloudSyncService _cloudSyncService = CloudSyncService();
  Box<ProgressModel>? _progressBox;
  ProgressModel? _currentProgress;

  ProgressModel get progress => _currentProgress ?? ProgressModel();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ProgressModelAdapter());
    }
    _progressBox = await Hive.openBox<ProgressModel>('progress');

    if (_progressBox!.isEmpty) {
      _currentProgress = ProgressModel();
      await _progressBox!.add(_currentProgress!);
    } else {
      _currentProgress = _progressBox!.getAt(0);
    }
    notifyListeners();
  }

  Future<void> updateStats({required int completed, required int total}) async {
    if (_currentProgress == null) return;

    _currentProgress!.completedTasksInGoal = completed;
    // Simple calculation for now
    if (total > 0) {
      _currentProgress!.disciplineScore = (completed / total) * 100;
    }
    _currentProgress!.lastUpdated = DateTime.now();

    await _currentProgress!.save();
    await _cloudSyncService.syncProgressToCloud(_currentProgress!);
    notifyListeners();
  }
}
