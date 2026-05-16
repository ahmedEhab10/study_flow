import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class CompletedContinar extends StatelessWidget {
  const CompletedContinar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.surface, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
        child: Row(
          children: [
            SvgPicture.asset(Assets.svgsFillCompleteIcon),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Read Literature Chapter 4',

                style: GoogleFonts.inter(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.colorScheme.onSurface.withAlpha(124),

                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withAlpha(124),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
