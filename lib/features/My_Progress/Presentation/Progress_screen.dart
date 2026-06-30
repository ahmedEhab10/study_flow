import 'package:flutter/material.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_body.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ProgressBody(),
      ),
    );
  }
}
