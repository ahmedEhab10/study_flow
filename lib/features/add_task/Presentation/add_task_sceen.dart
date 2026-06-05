import 'package:flutter/material.dart';
import 'package:study_flow/Core/Widgets/custom_app_bar.dart';
import 'package:study_flow/features/add_task/Presentation/widget/add_task_screen_body.dart';

class AddTaskSceen extends StatelessWidget {
  const AddTaskSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'New Study Task', context: context),
      body: AddTaskScreenBody(),
    );
  }
}
