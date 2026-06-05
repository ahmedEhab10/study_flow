import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Widgets/custom_app_bar.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/subject_screen_body.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  bool _isProgressMode = false;

  void _toggleProgressMode() {
    setState(() => _isProgressMode = !_isProgressMode);
  }

  @override
  Widget build(BuildContext context) {
    final currentSubject =
        context.watch<SubjectsCubit>().state.subjects.firstWhere(
              (element) => element.name == widget.subject.name,
              orElse: () => widget.subject,
            );

    return Scaffold(
      appBar: customAppBar(title: currentSubject.name, context: context),
      body: SubjectScreenBody(
        subject: currentSubject,
        isProgressMode: _isProgressMode,
        onProgressTap: _toggleProgressMode,
      ),
    );
  }
}
