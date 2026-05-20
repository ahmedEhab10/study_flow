import 'package:flutter/material.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Widgets/custom_app_bar.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/subject_screen_body.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final SubjectModel subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: subject.name, context: context),
      body: SubjectScreenBody(subject: subject),
    );
  }
}
