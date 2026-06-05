import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart' as subject_model;
import 'package:study_flow/Core/Widgets/Add_Subject_Sheet.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';

void showModernBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return AddSubjectSheet(
        title: 'Add New Subject',
        subtitle: 'Organize your study materials smarter',
        inputLabel: 'Subject Name',
        inputHint: 'e.g. Molecular Biology',
        ctaLabel: ' Add Subject',
        onSubmit: (name, accentColor, icon, pdfFiles) async {
          final List<PdfModel> pdfModels = [];
          try {
            final appDir = await getApplicationDocumentsDirectory();
            final pdfsDir = Directory('${appDir.path}/pdfs');
            if (!await pdfsDir.exists()) {
              await pdfsDir.create(recursive: true);
            }

            for (var file in pdfFiles) {
              if (file.path != null) {
                final originalFile = File(file.path!);
                final uniqueName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
                final targetPath = '${pdfsDir.path}/$uniqueName';
                await originalFile.copy(targetPath);

                pdfModels.add(
                  PdfModel(
                    title: file.name,
                    subjectName: name,
                    timeAgo: 'Opened just now',
                    filePath: targetPath,
                  ),
                );
              }
            }
          } catch (e) {
            debugPrint('Error saving PDFs in bottom sheet: $e');
          }

          final newSubject = subject_model.SubjectModel(
            name: name,
            subtitle: '${pdfModels.length} PDFs • 0 Notes',
            progress: 0.0,
            accent: accentColor,
            iconBg: accentColor.withValues(alpha: 0.1),
            icon: icon,
            pdfs: pdfModels,
            notes: [],
          );

          if (context.mounted) {
            context.read<SubjectsCubit>().addSubject(newSubject);
          }
        },
      );
    },
  );
}







// DraggableScrollableSheet(
//         initialChildSize: 0.8,
//         minChildSize: 0.3,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, scrollController) {
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.surface,
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(32),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.2),
//                   blurRadius: 20,
//                   offset: const Offset(0, -5),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _DragHandle(),
//                 Text(
//                   'Add New Subject',
//                   style: GoogleFonts.inter(
//                     color: theme.colorScheme.onSurface,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Organize your study materials smarter',
//                   style: GoogleFonts.inter(
//                     color: ColorsManager.textSecondaryDark,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'SUBJECT NAME',
//                   style: GoogleFonts.inter(
//                     color: theme.colorScheme.onSurface,
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 CustomInputTextFaild(
//                   controller: null,
//                   hint: 'e.g. Molecular Biology',
//                   accent: theme.colorScheme.surface,
//                 ),
//               ],
//             ),
//           );
//         },
//       );