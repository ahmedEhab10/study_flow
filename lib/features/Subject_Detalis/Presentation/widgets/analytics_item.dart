import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class AnalyticsItem extends StatelessWidget {
  const AnalyticsItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: MediaQuery.of(context).size.width,

      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.5, color: const Color(0x19717783)),
          borderRadius: BorderRadius.circular(24),
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
      child: Stack(
        children: [
          Positioned.fill(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/Images/completion_background.png',
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEEKLY PROGRESS',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '+15%',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    const SizedBox(width: 4),
                    Text(
                      'vs last week',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: ColorsManager.tartar,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/Images/analytics_background.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
