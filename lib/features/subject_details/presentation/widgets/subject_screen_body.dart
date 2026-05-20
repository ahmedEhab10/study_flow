import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Helper/subject_icon_pranter.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/Widgets/note_item.dart';
import 'package:study_flow/Core/Widgets/pdf_item.dart';
import 'package:study_flow/Core/Widgets/view_all_row.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/action_section.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/analytics_item.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/course_completion_container.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_item.dart';

class SubjectScreenBody extends StatelessWidget {
  final SubjectModel subject;

  const SubjectScreenBody({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomScrollPadding = 75.0 + MediaQuery.paddingOf(context).bottom;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SubjectIconWidget(
                      icon: subject.icon,
                      color: subject.accent,
                      size: 32.r,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subject.name,
                        style: GoogleFonts.inter(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${subject.pdfs.length} PDFs • ${subject.notes.length} Notes',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: ColorsManager.textSecondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                CourseCompletionContainer(progress: subject.progress),
                const SizedBox(height: 24),
                ActionSection(
                  onAddPdfTap: () {
                    // Handled in Phase 4
                  },
                  onAddNoteTap: () {
                    // Handled in Phase 3/4
                  },
                  onProgressTap: () {
                    // Dynamic stats
                  },
                ),
                const SizedBox(height: 24),
                const ViewAllRow(title: 'Study Materials'),
                const SizedBox(height: 16),
                if (subject.pdfs.isEmpty)
                  _buildEmptyPlaceholder(
                    theme,
                    'No PDFs uploaded yet. Tap "Add PDF" to upload study materials.',
                  )
                else
                  ...subject.pdfs.map((pdf) => PdfItem(pdf: pdf)),
                const SizedBox(height: 16),
                const ViewAllRow(title: 'Recent Notes'),
                const SizedBox(height: 16),
                if (subject.notes.isEmpty)
                  _buildEmptyPlaceholder(
                    theme,
                    'No notes created yet. Tap "Add Note" to write one.',
                  )
                else
                  ...subject.notes.map((note) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: NoteItem(note: note),
                      )),
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
                const AnalyticsItem(),
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

  Widget _buildEmptyPlaceholder(ThemeData theme, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
