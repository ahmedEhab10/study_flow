import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class CourseCompletionContinar extends StatelessWidget {
  const CourseCompletionContinar({super.key});

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
                  'COURSE COMPLETION',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsManager.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '68%',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SvgPicture.asset('assets/Svgs/doing_great_icon.svg'),
                        const SizedBox(width: 4),
                        Text(
                          'You\'re doing great!',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: ColorsManager.tartar,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 0.68),
                  duration: const Duration(milliseconds: 1200),

                  curve: Curves.easeOutCubic,

                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),

                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 7.r,
                        backgroundColor: ColorsManager.primaryDark,

                        valueColor: AlwaysStoppedAnimation(
                          ColorsManager.primary,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
