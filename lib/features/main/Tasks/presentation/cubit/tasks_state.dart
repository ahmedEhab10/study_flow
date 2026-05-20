import 'package:study_flow/Core/Models/Task_Model.dart';

abstract class TasksState {
  final List<TaskModel> tasks;
  const TasksState({required this.tasks});
}

class TasksInitial extends TasksState {
  const TasksInitial({required super.tasks});
}

class TasksLoaded extends TasksState {
  const TasksLoaded({required super.tasks});
}
