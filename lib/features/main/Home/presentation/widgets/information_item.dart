import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class InformationItem extends StatelessWidget {
  const InformationItem({
    super.key,
    required this.title,
    required this.icon,
    required this.theinfo,
  });
  final String title, icon, theinfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      // height: 135.h,
      width: 160.w,
      decoration: BoxDecoration(
        color: Color(0xffE2E2EC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.fromBorderSide(
          BorderSide(color: Colors.grey.shade300, width: 2.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(icon),
          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF414751),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            theinfo,
            style: GoogleFonts.inter(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
