import 'package:flutter/material.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/action_button.dart';

class ActionSection extends StatelessWidget {
  const ActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            onTap: () {},
            title: 'Add PDF',
            icon: Assets.svgsAddPdfIcon,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActionButton(
            onTap: () {},
            title: 'Add Note',
            icon: Assets.svgsAddNoteIcon,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ActionButton(
            onTap: () {},
            title: 'Progress',
            icon: Assets.svgsProgressIcon,
          ),
        ),
      ],
    );
  }
}
