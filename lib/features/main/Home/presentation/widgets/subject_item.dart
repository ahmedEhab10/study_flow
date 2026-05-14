import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Helper/subject_icon_pranter.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class SubjectItem extends StatelessWidget {
  const SubjectItem({
    super.key,
    required this.subject,
    this.onTap,
    this.isLarge = false,
  });

  final SubjectModel subject;
  final VoidCallback? onTap;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: isLarge ? 210.h : 190.h,
          maxHeight: isLarge ? 240.h : 220.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP ACCENT
            Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: subject.accent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ICON
                    Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        color: subject.iconBg,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: SubjectIconWidget(
                          icon: subject.icon,
                          color: subject.accent,
                          size: 26,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// TITLE
                    Text(
                      subject.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                        color: const Color(0xFF1A1D2E),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    /// SUBTITLE
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      subject.subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7B8190),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Spacer(),

                    /// PROGRESS HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          '${(subject.progress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: subject.accent,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// ANIMATED PROGRESS
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: subject.progress),
                      duration: const Duration(milliseconds: 1200),

                      curve: Curves.easeOutCubic,

                      builder: (context, value, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),

                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 5.r,
                            backgroundColor: subject.iconBg,

                            valueColor: AlwaysStoppedAnimation(subject.accent),
                          ),
                        );
                      },
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
