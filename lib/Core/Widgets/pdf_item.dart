import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class pdfitem extends StatelessWidget {
  const pdfitem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: theme.colorScheme.surface,

          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: const Color(0x19717783)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          shadows: [
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
                    'Cellular Structure.pdf',
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
                    'Biology - Opened 2 hours ago',
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
    );
  }
}



// ShapeDecoration(
//         color: theme.colorScheme.surface,
//         shape: RoundedRectangleBorder(
//           side: BorderSide(width: 1.5, color: const Color(0x19717783)),
//           borderRadius: BorderRadius.circular(24),
//         ),
//         shadows: [
//           BoxShadow(
//             color: Color(0x0C000000),
//             blurRadius: 2,
//             offset: Offset(0, 1),
//             spreadRadius: 0,
//           ),
//         ],
//       ),