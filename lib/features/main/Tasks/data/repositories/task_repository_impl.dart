import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/features/main/Tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String _boxName = 'tasks_box';

  Box get _box => Hive.box(_boxName);

  @override
  Future<List<TaskModel>> getTasks() async {
    final List<TaskModel> loadedTasks = [];
    for (var key in _box.keys) {
      final Map<dynamic, dynamic> map = _box.get(key) as Map<dynamic, dynamic>;
      loadedTasks.add(TaskModel.fromJson(map));
    }
    return loadedTasks;
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task.toJson());
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final taskMap = _box.get(id) as Map<dynamic, dynamic>?;
    if (taskMap != null) {
      final task = TaskModel.fromJson(taskMap);
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _box.put(id, updatedTask.toJson());
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }
}
