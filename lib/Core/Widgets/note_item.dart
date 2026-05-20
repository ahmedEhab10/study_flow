import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class NoteItem extends StatelessWidget {
  final NoteModel? note;
  final VoidCallback? onTap;

  const NoteItem({super.key, this.note, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayTitle = note?.title ?? 'Mitochondria functions';
    final displayContent = note?.content ??
        'Powerhouse of the cell. Generates most of the\nchemical energy needed to power the cell\'s…';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.5, color: Color(0x19717783)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(Assets.svgsNoteIitemCon),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              displayContent,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
