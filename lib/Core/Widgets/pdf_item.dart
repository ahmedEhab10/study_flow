import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class PdfItem extends StatelessWidget {
  final PdfModel? pdf;
  final VoidCallback? onTap;
  final bool isProgressMode;
  final ValueChanged<bool>? onCompletionToggled;
  /// When false (default), the item ignores completion state for styling.
  /// Set to true only in the Subject progress-tracker view.
  final bool showCompletionStyle;

  const PdfItem({
    super.key,
    this.pdf,
    this.onTap,
    this.isProgressMode = false,
    this.onCompletionToggled,
    this.showCompletionStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final displayTitle = pdf?.title ?? 'Cellular Structure.pdf';
    final displaySubtitle = pdf != null 
        ? '${pdf!.subjectName} - ${pdf!.timeAgo}' 
        : 'Biology - Opened 2 hours ago';

    final isCompleted = showCompletionStyle && (pdf?.isCompleted ?? false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: isProgressMode
            ? () => onCompletionToggled?.call(!isCompleted)
            : (onTap ?? () async {
                if (pdf?.filePath != null) {
                  try {
                    final result = await OpenFilex.open(pdf!.filePath!);
                    if (kDebugMode) {
                      print('Open file result: ${result.message}');
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error opening file: $e');
                    }
                  }
                }
              }),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16.r),
          decoration: ShapeDecoration(
            color: isCompleted
                ? (isDark
                    ? ColorsManager.primary.withValues(alpha: 0.08)
                    : ColorsManager.primary.withValues(alpha: 0.04))
                : theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.5,
                color: isCompleted
                    ? ColorsManager.primary.withValues(alpha: 0.35)
                    : const Color(0x19717783),
              ),
              borderRadius: BorderRadius.circular(12.r),
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
          child: Row(
            children: [
              if (isProgressMode)
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: Checkbox(
                      value: isCompleted,
                      onChanged: (val) => onCompletionToggled?.call(val ?? false),
                      activeColor: ColorsManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              SvgPicture.asset(Assets.svgsPdfSvg, width: 40.r, height: 40.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isCompleted
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurface,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      displaySubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
