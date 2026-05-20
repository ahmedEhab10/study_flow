import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_cubit.dart';

class InformationList extends StatelessWidget {
  const InformationList({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksCubit>().state.tasks;
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final totalCount = tasks.length;
    final tasksInfo = '$completedCount/$totalCount';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 340;

        if (isNarrow) {
          return Column(
            children: [
              const InformationItem(
                title: 'Daily Streak',
                icon: Assets.svgsStreak,
                theinfo: '3 days',
              ),
              SizedBox(height: 12.h),
              InformationItem(
                title: 'Tasks Done',
                icon: Assets.svgsDone,
                theinfo: tasksInfo,
              ),
            ],
          );
        }

        return Row(
          children: [
            const Expanded(
              child: InformationItem(
                title: 'Daily Streak',
                icon: Assets.svgsStreak,
                theinfo: '3 days',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: InformationItem(
                title: 'Tasks Done',
                icon: Assets.svgsDone,
                theinfo: tasksInfo,
              ),
            ),
          ],
        );
      },
    );
  }
}
