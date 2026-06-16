import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/features/main/Tasks/domain/repositories/task_repository.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository _taskRepository;

  TasksCubit(this._taskRepository) : super(const TasksInitial(tasks: [])) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final loadedTasks = await _taskRepository.getTasks();
    emit(TasksLoaded(tasks: loadedTasks));
  }

  Future<void> addTask(TaskModel task) async {
    await _taskRepository.addTask(task);
    final updatedTasks = List<TaskModel>.from(state.tasks)..add(task);
    emit(TasksLoaded(tasks: updatedTasks));
  }

  Future<void> toggleTaskStatus(String id) async {
    await _taskRepository.toggleTaskStatus(id);
    final updatedTasks = state.tasks.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }

  Future<void> deleteTask(String id) async {
    await _taskRepository.deleteTask(id);
    final updatedTasks = state.tasks.where((task) => task.id != id).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }
}
