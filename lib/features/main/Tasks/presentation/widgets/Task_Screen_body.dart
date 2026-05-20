import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_cubit.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/completed_container.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/progress_container.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/task_container.dart';

class TaskScreenBody extends StatelessWidget {
  const TaskScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomScrollPadding = 75.0 + MediaQuery.paddingOf(context).bottom + 24.h;

    final tasks = context.watch<TasksCubit>().state.tasks;
    final todayTasks = tasks.where((t) => t.dueCategory == 'today' && !t.isCompleted).toList();
    final tomorrowTasks = tasks.where((t) => t.dueCategory == 'tomorrow' && !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    final totalCount = tasks.length;
    final completedCount = completedTasks.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Tasks',
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stay focused. ${todayTasks.length} tasks pending today.',
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 24),
                ProgressContainer(
                  completedTasks: completedCount,
                  totalTasks: totalCount,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SvgPicture.asset(Assets.svgsCalender),
                    const SizedBox(width: 8),
                    Text(
                      'Today',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          if (todayTasks.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(theme, 'No tasks pending today!'),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = todayTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TaskContainer(
                      task: task,
                      onChanged: (val) {
                        context.read<TasksCubit>().toggleTaskStatus(task.id);
                      },
                    ),
                  );
                },
                childCount: todayTasks.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    SvgPicture.asset('assets/Svgs/upcome_icon.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'Tomorrow',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          if (tomorrowTasks.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(theme, 'No upcoming tasks tomorrow.'),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = tomorrowTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TaskContainer(
                      task: task,
                      onChanged: (val) {
                        context.read<TasksCubit>().toggleTaskStatus(task.id);
                      },
                    ),
                  );
                },
                childCount: tomorrowTasks.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    SvgPicture.asset('assets/Svgs/complet_icon.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'Completed',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          if (completedTasks.isEmpty)
            SliverToBoxAdapter(
              child: _buildEmptyState(theme, 'No completed tasks yet.'),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = completedTasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CompletedContainer(
                      task: task,
                      onToggle: () {
                        context.read<TasksCubit>().toggleTaskStatus(task.id);
                      },
                    ),
                  );
                },
                childCount: completedTasks.length,
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
