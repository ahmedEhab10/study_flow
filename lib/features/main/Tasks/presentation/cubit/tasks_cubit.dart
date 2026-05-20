import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  static const String _boxName = 'tasks_box';

  TasksCubit() : super(const TasksInitial(tasks: [])) {
    loadTasks();
  }

  void loadTasks() {
    final box = Hive.box(_boxName);
    final List<TaskModel> loadedTasks = [];

    if (box.isEmpty) {
      // Seed initial mock tasks if database is empty
      final initialTasks = [
        const TaskModel(
          id: '1',
          title: 'Review Cell Biology Notes',
          subjectName: 'Biology',
          pdfTitle: 'Cell_Basics.pdf',
          isCompleted: false,
          dueCategory: 'today',
        ),
        const TaskModel(
          id: '2',
          title: 'Solve Physics Quiz 2',
          subjectName: 'Physics',
          pdfTitle: null,
          isCompleted: false,
          dueCategory: 'today',
        ),
        const TaskModel(
          id: '3',
          title: 'Read Literature Chapter 4',
          subjectName: 'Literature',
          pdfTitle: null,
          isCompleted: false,
          dueCategory: 'tomorrow',
        ),
        const TaskModel(
          id: '4',
          title: 'Chemistry Lab Report',
          subjectName: 'Chemistry',
          pdfTitle: 'Lab_Instructions.pdf',
          isCompleted: true,
          dueCategory: 'today',
        ),
      ];

      for (var task in initialTasks) {
        box.put(task.id, task.toJson());
        loadedTasks.add(task);
      }
    } else {
      for (var key in box.keys) {
        final Map<dynamic, dynamic> map = box.get(key) as Map<dynamic, dynamic>;
        loadedTasks.add(TaskModel.fromJson(map));
      }
    }

    emit(TasksLoaded(tasks: loadedTasks));
  }

  void addTask(TaskModel task) {
    final box = Hive.box(_boxName);
    box.put(task.id, task.toJson());
    
    final updatedTasks = List<TaskModel>.from(state.tasks)..add(task);
    emit(TasksLoaded(tasks: updatedTasks));
  }

  void toggleTaskStatus(String id) {
    final box = Hive.box(_boxName);
    final updatedTasks = state.tasks.map((task) {
      if (task.id == id) {
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        box.put(id, updatedTask.toJson());
        return updatedTask;
      }
      return task;
    }).toList();
    
    emit(TasksLoaded(tasks: updatedTasks));
  }

  void deleteTask(String id) {
    final box = Hive.box(_boxName);
    box.delete(id);
    
    final updatedTasks = state.tasks.where((task) => task.id != id).toList();
    emit(TasksLoaded(tasks: updatedTasks));
  }
}
