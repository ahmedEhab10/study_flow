import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/Widgets/note_item.dart';
import 'package:study_flow/Core/Widgets/pdf_item.dart';
import 'package:study_flow/Core/Widgets/view_all_row.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/action_button.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/action_section.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/analytics_item.dart';
import 'package:study_flow/features/Subject_Detalis/Presentation/widgets/course_completion_continar.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_item.dart';

class SubjectScreenBody extends StatelessWidget {
  const SubjectScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomScrollPadding = 75.0 + MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.svgsBiolgyIcon),
                    const SizedBox(width: 8),
                    Text(
                      'Biology',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '12 PDFs • 24 Study Hours',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: ColorsManager.textSecondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                CourseCompletionContinar(),
                const SizedBox(height: 24),
                ActionSection(),
                const SizedBox(height: 24),
                ViewAllRow(title: 'Study Materials'),
                const SizedBox(height: 16),
                pdfitem(),

                pdfitem(),
                const SizedBox(height: 16),
                ViewAllRow(title: 'Recent Notes'),
                const SizedBox(height: 16),
                NoteItem(),
                SizedBox(height: 6),
                NoteItem(),

                const SizedBox(height: 16),
                Text(
                  'Analytics',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                AnalyticsItem(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: InformationItem(
                        title: 'DAY STREAK',
                        icon: Assets.svgsStreak,
                        theinfo: '3 days',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    const Expanded(
                      child: InformationItem(
                        title: 'TOTAL STUDY TIME',
                        icon: Assets.svgsTime,
                        theinfo: '6h 30m',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
      ],
    );
  }
}
