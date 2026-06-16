import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class ReferenceMaterial extends StatelessWidget {
  final PdfModel pdf;
  final bool isSelected;
  final VoidCallback? onTap;

  const ReferenceMaterial({
    super.key,
    required this.pdf,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 200.w,
        padding: EdgeInsets.all(12.r),
        decoration: ShapeDecoration(
          color: isSelected 
              ? (isDark ? ColorsManager.primary.withValues(alpha: 0.15) : ColorsManager.primary.withValues(alpha: 0.08))
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              color: isSelected 
                  ? ColorsManager.primary 
                  : (isDark ? Colors.grey.shade800 : const Color(0x19717783)),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: [
            BoxShadow(
              color: isSelected 
                  ? ColorsManager.primary.withValues(alpha: 0.1)
                  : const Color(0x0C000000),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Assets.svgsPdfSvg,
                  width: 32.r,
                  height: 32.r,
                ),
                if (isSelected)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pdf.title,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    pdf.subjectName,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
