import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final void Function()? onTap;
  final String title, icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Color(0xffE2E2EC),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    isDark ? Color(0xff005DA7) : Color(0xff005DA7),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
