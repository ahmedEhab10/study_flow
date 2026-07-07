import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_flow/Core/Helper/subject_icon_pranter.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/course_completion_container.dart';
import 'package:study_flow/Core/Widgets/pdf_item.dart';
import 'package:study_flow/Core/Widgets/view_all_row.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/action_section.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/add_note_sheet.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/expandable_note_item.dart';
import 'package:study_flow/features/subject_details/presentation/widgets/subject_analytics_section.dart';

class SubjectScreenBody extends StatelessWidget {
  final SubjectModel subject;
  final bool isProgressMode;
  final VoidCallback? onProgressTap;

  const SubjectScreenBody({
    super.key,
    required this.subject,
    this.isProgressMode = false,
    this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomScrollPadding = 75.0 + MediaQuery.paddingOf(context).bottom;
    final cubit = context.read<SubjectsCubit>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    GestureDetector(
                      onTap: () async {
                        await cubit.deleteSubject(subject.name);
                        if (context.mounted && Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.red,
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
                  onStudySessionTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.study_session,
                      arguments: subject,
                    );
                  },
                  onAddPdfTap: () async {
                    try {
                      final result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowMultiple: true,
                      );
                      if (result != null) {
                        if (!context.mounted) return;
                        final appDir = await getApplicationDocumentsDirectory();
                        final pdfsDir = Directory('${appDir.path}/pdfs');
                        if (!await pdfsDir.exists()) {
                          await pdfsDir.create(recursive: true);
                        }

                        int largeFileCount = 0;
                        for (var file in result.files) {
                          if (file.size <= 25 * 1024 * 1024) {
                            if (file.path != null) {
                              final originalFile = File(file.path!);
                              final uniqueName =
                                  '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
                              final targetPath = '${pdfsDir.path}/$uniqueName';
                              await originalFile.copy(targetPath);

                              final pdf = PdfModel(
                                title: file.name,
                                subjectName: subject.name,
                                timeAgo: 'Opened just now',
                                filePath: targetPath,
                              );
                              cubit.addPdfToSubject(subject.name, pdf);
                            }
                          } else {
                            largeFileCount++;
                          }
                        }

                        if (context.mounted) {
                          if (largeFileCount > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$largeFileCount file(s) exceeded the 25MB limit and were not added.',
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('PDF(s) uploaded successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      debugPrint('Error picking/uploading PDFs: $e');
                    }
                  },
                  onAddNoteTap: () => showAddNoteSheet(context, subject.name),
                  onProgressTap: onProgressTap,
                ),
                if (isProgressMode) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Tap checkboxes to mark items as complete',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.primary,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const ViewAllRow(title: 'Study Materials'),
                const SizedBox(height: 16),
                if (subject.pdfs.isEmpty)
                  _buildEmptyPlaceholder(
                    theme,
                    'No PDFs uploaded yet. Tap "Add PDF" to upload study materials.',
                  )
                else
                  ...subject.pdfs.map(
                    (pdf) => PdfItem(
                      pdf: pdf,
                      isProgressMode: isProgressMode,
                      showCompletionStyle: isProgressMode,
                      onCompletionToggled: isProgressMode
                          ? (isCompleted) => cubit.updatePdfCompletion(
                              subject.name,
                              pdf.id,
                              isCompleted,
                            )
                          : null,
                    ),
                  ),
                const SizedBox(height: 16),
                const ViewAllRow(title: 'Recent Notes'),
                const SizedBox(height: 16),
                if (subject.notes.isEmpty)
                  _buildEmptyPlaceholder(
                    theme,
                    'No notes created yet. Tap "Add Note" to write one.',
                  )
                else
                  ...subject.notes.map(
                    (note) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: ExpandableNoteItem(
                        note: note,
                        isProgressMode: isProgressMode,
                        onCompletionToggled: isProgressMode
                            ? (isCompleted) => cubit.updateNoteCompletion(
                                subject.name,
                                note.id,
                                isCompleted,
                              )
                            : null,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SubjectAnalyticsSection(subjectName: subject.name),
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
