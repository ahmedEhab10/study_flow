import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/features/main/Tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  static const String _boxName = 'tasks_box';

  Box get _box => Hive.box(_boxName);

  @override
  Future<List<TaskModel>> getTasks() async {
    final List<TaskModel> loadedTasks = [];

    if (_box.isEmpty) {
      final initialTasks = [
        const TaskModel(
          id: '1',
          title: 'Focus on chloroplasts, mitochondria, and cell division structures described in Chapter 4.',
          subjectName: 'Biology',
          pdfTitle: 'Cell_Basics.pdf',
          isCompleted: false,
          dueCategory: 'today',
        ),
        const TaskModel(
          id: '2',
          title: 'Problems 1 through 15 on Newtonian kinematics, acceleration, and projectile motion.',
          subjectName: 'Physics',
          pdfTitle: null,
          isCompleted: false,
          dueCategory: 'today',
        ),
        const TaskModel(
          id: '3',
          title: 'Prepare brief character analysis of Hamlet\'s soliloquy regarding action versus inaction.',
          subjectName: 'Literature',
          pdfTitle: null,
          isCompleted: false,
          dueCategory: 'tomorrow',
        ),
        const TaskModel(
          id: '4',
          title: 'Detail the sharing of electron pairs in covalent bonding. Clean up the final diagram page.',
          subjectName: 'Chemistry',
          pdfTitle: 'Lab_Instructions.pdf',
          isCompleted: true,
          dueCategory: 'today',
        ),
      ];

      for (var task in initialTasks) {
        await _box.put(task.id, task.toJson());
        loadedTasks.add(task);
      }
    } else {
      for (var key in _box.keys) {
        final Map<dynamic, dynamic> map = _box.get(key) as Map<dynamic, dynamic>;
        loadedTasks.add(TaskModel.fromJson(map));
      }
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
