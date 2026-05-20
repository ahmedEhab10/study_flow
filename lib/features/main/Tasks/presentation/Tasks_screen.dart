import 'package:flutter/material.dart';
import 'package:study_flow/Core/Widgets/custom_floating_action_button.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/Task_Screen_body.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(onPressed: () {}),
      body: SafeArea(child: TaskScreenBody()),
    );
  }
}
