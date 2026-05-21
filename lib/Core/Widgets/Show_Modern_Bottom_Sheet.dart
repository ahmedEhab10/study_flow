import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Widgets/custom_input_text_faild.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/Core/Widgets/Add_Subject_Sheet.dart';

void showModernBottomSheet(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // backgroundColor: Colors.transparent,
    // barrierColor: Colors.black.withOpacity(.4),
    builder: (context) {
      return AddSubjectSheet(
        title: 'Add New Subject',
        subtitle: 'Organize your study materials smarter',
        inputLabel: 'Subject Name',
        inputHint: 'e.g. Molecular Biology',
        ctaLabel: ' Add Subject',
      );
    },
  );
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 4),
        width: 50,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
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