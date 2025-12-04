import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:my_routine/features/tasks/db/task_db.dart';
import 'package:my_routine/features/tasks/models/task_model.dart';
import 'package:my_routine/services/notification_service.dart';
import 'package:my_routine/services/cloud_sync_service.dart';

class TaskController extends ChangeNotifier {
  final TaskDB _taskDB = TaskDB();
  final NotificationService _notificationService = NotificationService();
  final CloudSyncService _syncService = CloudSyncService();
  final Uuid _uuid = const Uuid();

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  Future<void> loadTasks() async {
    _tasks = await _taskDB.getTasks();
    // Sort by time
    _tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> addTask(String title, DateTime dateTime) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      dateTime: dateTime,
      updatedAt: DateTime.now(),
    );
    await _taskDB.addTask(task);
    await _syncService.syncTask(task);

    // Schedule notification 5 minutes before
    final scheduledTime = dateTime.subtract(const Duration(minutes: 5));
    if (scheduledTime.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: task.id.hashCode,
        title: 'Upcoming Task',
        body: '$title is starting in 5 minutes!',
        scheduledDate: scheduledTime,
      );
    }

    await loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    task.updatedAt = DateTime.now();
    await _taskDB.updateTask(task);
    await _syncService.syncTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    await _taskDB.deleteTask(task);
    await _syncService.deleteTask(task.id ?? '');
    await loadTasks();
  }
}
