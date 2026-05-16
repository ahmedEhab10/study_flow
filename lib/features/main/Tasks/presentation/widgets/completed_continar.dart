import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class CompletedContinar extends StatelessWidget {
  const CompletedContinar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 2),
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
                  decorationColor: Color.fromARGB(85, 65, 71, 81),

                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(85, 65, 71, 81),
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
