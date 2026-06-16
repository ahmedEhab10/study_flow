import 'package:study_flow/Core/Models/Task_Model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> toggleTaskStatus(String id);
  Future<void> deleteTask(String id);
}
