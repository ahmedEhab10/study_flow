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
  final bool isProgressMode;
  final bool isCompleted;
  final ValueChanged<bool>? onCompletionToggled;
  final VoidCallback? onTap;

  const PdfItem({
    super.key,
    this.pdf,
    this.isProgressMode = false,
    this.isCompleted = false,
    this.onCompletionToggled,
    this.onTap,
  });

  Future<void> _openPdf(BuildContext context) async {
    final filePath = pdf?.filePath;
    if (filePath == null || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file path available for this PDF.')),
      );
      return;
    }

    final result = await OpenFilex.open(filePath);
    if (!context.mounted) return;
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      _openPdf(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final completed = pdf?.isCompleted ?? isCompleted;

    final displayTitle = pdf?.title ?? 'Cellular Structure.pdf';
    final displaySubtitle = pdf != null
        ? '${pdf!.subjectName} - ${pdf!.timeAgo}'
        : 'Biology - Opened 2 hours ago';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: completed
              ? (isDark
                  ? ColorsManager.primary.withValues(alpha: 0.08)
                  : ColorsManager.primary.withValues(alpha: 0.04))
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: completed
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
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: isProgressMode
                  ? Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: Checkbox(
                          value: completed,
                          onChanged: (val) {
                            onCompletionToggled?.call(val ?? false);
                          },
                          activeColor: ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _handleTap(context),
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.svgsPdfSvg,
                      width: 40.r,
                      height: 40.r,
                    ),
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
                              color: completed
                                  ? theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5)
                                  : theme.colorScheme.onSurface,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
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
          ],
        ),
      ),
    );
  }
}
