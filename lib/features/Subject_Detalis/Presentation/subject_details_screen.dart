import 'package:flutter/material.dart';
import 'package:study_flow/Core/Widgets/custom_app_bar.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/subject_screen_body.dart';

class SubjectDetailsScreen extends StatelessWidget {
  const SubjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Subject Details', context: context),
      body: SubjectScreenBody(),
    );
  }
}
