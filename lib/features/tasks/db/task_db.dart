import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_routine/features/tasks/models/task_model.dart';

class TaskDB {
  static const String boxName = 'tasksBox';

  Future<Box<Task>> get _box async => await Hive.openBox<Task>(boxName);

  Future<void> addTask(Task task) async {
    final box = await _box;
    await box.add(task);
  }

  Future<List<Task>> getTasks() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }
}
