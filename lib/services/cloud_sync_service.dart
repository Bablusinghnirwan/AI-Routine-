import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
import 'package:my_routine/features/tasks/models/task_model.dart';
import 'package:my_routine/features/diary/diary_model.dart';
import 'package:my_routine/features/goals/goal_model.dart';
import 'package:my_routine/features/progress/progress_model.dart';
import 'package:my_routine/features/summary/summary_model.dart';
import 'package:flutter/foundation.dart';

class CloudSyncService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> loadCloudDataOnLogin() async {
    await pullCloudData();
    listenRealtimeChanges();
  }

  Future<void> pullCloudData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Pull Tasks
      final tasksData = await _supabase.from('tasks').select();
      final tasksBox = Hive.box<Task>('tasks'); // Assuming box name is 'tasks'

      for (final map in tasksData) {
        final task = Task.fromMap(map);
        // Conflict resolution: if local is newer, keep local (and maybe push?).
        // For simplicity: Cloud wins on pull (overwrite local).
        // Or: if local doesn't exist, add. If exists, check updated_at.

        if (tasksBox.containsKey(task.id)) {
          final localTask = tasksBox.get(task.id);
          if (localTask != null &&
              localTask.updatedAt.isAfter(task.updatedAt)) {
            // Local is newer, push to cloud
            await syncTask(localTask);
            continue;
          }
        }
        await tasksBox.put(task.id, task); // Use ID as key
      }

      // TODO: Pull Diary, Goals, etc.
    } catch (e) {
      debugPrint('Error pulling cloud data: $e');
    }
  }

  void listenRealtimeChanges() {
    _supabase
        .channel('public:tasks')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (payload) {
            // Handle changes
            // If INSERT/UPDATE: update local Hive
            // If DELETE: delete from local Hive
            // Be careful not to loop if we just pushed this change.
            // Usually we check if the change originated from us, but Supabase Realtime
            // doesn't easily tell us that unless we use a unique client ID in the payload.
            // For now, we can just apply it.
          },
        )
        .subscribe();
  }

  // --- Tasks ---
  Future<void> syncTask(Task task) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('tasks').upsert(task.toMap());
    } catch (e) {
      debugPrint('Error syncing task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('tasks').delete().eq('id', taskId);
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  // --- Diary ---
  Future<void> syncDiary(DiaryModel diaryEntry) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('diary').upsert(diaryEntry.toMap());
    } catch (e) {
      debugPrint('Error syncing diary: $e');
    }
  }

  Future<void> deleteDiary(String diaryId) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('diary').delete().eq('id', diaryId);
    } catch (e) {
      debugPrint('Error deleting diary: $e');
    }
  }

  // --- Goals ---
  Future<void> syncGoalToCloud(GoalModel goal) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('goals').upsert(goal.toMap());
    } catch (e) {
      debugPrint('Error syncing goal: $e');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('goals').delete().eq('id', goalId);
    } catch (e) {
      debugPrint('Error deleting goal: $e');
    }
  }

  // --- Progress ---
  Future<void> syncProgressToCloud(ProgressModel progress) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      // Progress usually has one entry per user per week or just one entry per user?
      // Assuming one entry per user for now based on model (no ID field, likely user_id is PK or unique)
      // But model doesn't have ID. It relies on user_id.
      // Upsert needs a unique constraint.
      await _supabase.from('progress').upsert(progress.toMap());
    } catch (e) {
      debugPrint('Error syncing progress: $e');
    }
  }

  // --- Summary ---
  Future<void> syncSummary(SummaryModel summary) async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _supabase.from('summary').upsert(summary.toMap());
    } catch (e) {
      debugPrint('Error syncing summary: $e');
    }
  }
}
