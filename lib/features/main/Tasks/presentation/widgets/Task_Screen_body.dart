import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/completed_continar.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/progress_continar.dart';
import 'package:study_flow/features/main/Tasks/presentation/widgets/task_continar.dart';

class TaskScreenBody extends StatelessWidget {
  const TaskScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomScrollPadding =
        75.0 + MediaQuery.paddingOf(context).bottom + 24.h;
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
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Stay focused. 5 tasks pending today.',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF414751),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 24),
                ProgressContinar(),
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
                SizedBox(height: 12),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TaskContinar(),
              ),
              childCount: 2,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 24),
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
                SizedBox(height: 12),
                TaskContinar(),
                SizedBox(height: 24),
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
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CompletedContinar(),
              ),
              childCount: 3,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
        ],
      ),
    );
  }
}
