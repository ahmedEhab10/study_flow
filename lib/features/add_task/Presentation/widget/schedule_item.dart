import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
  });
  final String title, icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(vertical: 14.r),
      decoration: ShapeDecoration(
        color: isSelected 
            ? (isDark ? ColorsManager.primary.withValues(alpha: 0.2) : ColorsManager.primary.withValues(alpha: 0.08))
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              isSelected 
                  ? ColorsManager.primary 
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.inter(
              color: isSelected 
                  ? ColorsManager.primary 
                  : theme.colorScheme.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
