import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class PdfItem extends StatelessWidget {
  final PdfModel? pdf;
  final VoidCallback? onTap;

  const PdfItem({super.key, this.pdf, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final displayTitle = pdf?.title ?? 'Cellular Structure.pdf';
    final displaySubtitle = pdf != null 
        ? '${pdf!.subjectName} - ${pdf!.timeAgo}' 
        : 'Biology - Opened 2 hours ago';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(16.r),
          decoration: ShapeDecoration(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.5, color: Color(0x19717783)),
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
                        color: theme.colorScheme.onSurface,
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