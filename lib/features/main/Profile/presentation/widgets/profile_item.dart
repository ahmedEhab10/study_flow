// ─── Appearance Card (with ThemeToggle) ──────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class profileItem extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String label;
  final IconData? icon;
  final String? svgicon;
  const profileItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.label,
    this.icon,
    this.svgicon,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                theme.dividerTheme.color ??
                ColorsManager.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            // Theme toggle row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: ColorsManager.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: svgicon != null
                        ? Center(
                            child: SvgPicture.asset(
                              svgicon!,
                              color: ColorsManager.primary,
                            ),
                          )
                        : Icon(icon, size: 18.r, color: ColorsManager.primary),
                  ),
                  SizedBox(width: 14.w),
                  // Label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.r,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
