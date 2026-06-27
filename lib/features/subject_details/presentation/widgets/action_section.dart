import 'package:flutter/material.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/action_button.dart';

class ActionSection extends StatelessWidget {
  final VoidCallback? onAddPdfTap;
  final VoidCallback? onAddNoteTap;
  final VoidCallback? onProgressTap;
  final VoidCallback? onStudySessionTap;

  const ActionSection({
    super.key,
    this.onAddPdfTap,
    this.onAddNoteTap,
    this.onProgressTap,
    this.onStudySessionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            onTap: onAddPdfTap,
            title: 'Add PDF',
            icon: Assets.svgsAddPdfIcon,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: ActionButton(
            onTap: onStudySessionTap,
            title: ' Study',
            icon: 'assets/Svgs/study_session.svg',
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: ActionButton(
            onTap: onAddNoteTap,
            title: 'Add Note',
            icon: Assets.svgsAddNoteIcon,
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: ActionButton(
            onTap: onProgressTap,
            title: 'Progress',
            icon: Assets.svgsProgressIcon,
          ),
        ),
      ],
    );
  }
}
