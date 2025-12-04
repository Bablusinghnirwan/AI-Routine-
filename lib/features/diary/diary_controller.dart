import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_routine/features/diary/diary_model.dart';
import 'package:uuid/uuid.dart';
import 'package:my_routine/services/cloud_sync_service.dart';

class DiaryController extends ChangeNotifier {
  final CloudSyncService _syncService = CloudSyncService();
  Box<DiaryModel>? _diaryBox;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> init() async {
    _diaryBox = await Hive.openBox<DiaryModel>('diary');
    notifyListeners();
  }

  Future<void> addEntry(
    String text, {
    String mood = '😊',
    int color = 0xFF11002F,
  }) async {
    if (_diaryBox == null) return;

    _isLoading = true;
    notifyListeners();

    final entry = DiaryModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      rawText: text,
      updatedAt: DateTime.now(),
      mood: mood,
      color: color,
      // AI features for diary can be added later or reused from summary
    );

    await _diaryBox?.add(entry);
    await _syncService.syncDiary(entry);

    _isLoading = false;
    notifyListeners();
  }

  List<DiaryModel> getEntries() {
    if (_diaryBox == null) return [];
    return _diaryBox!.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> deleteEntry(int index) async {
    final entry = _diaryBox?.getAt(index);
    if (entry != null) {
      await _syncService.deleteDiary(entry.id);
    }
    await _diaryBox?.deleteAt(index);
    notifyListeners();
  }
}
