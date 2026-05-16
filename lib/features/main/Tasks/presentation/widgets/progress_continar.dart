import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class ProgressContinar extends StatelessWidget {
  const ProgressContinar({super.key});
  final int completedTasks = 6;
  final int totalTasks = 8;

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    return Container(
      width: MediaQuery.of(context).size.width,

      decoration: BoxDecoration(
        color: ColorsManager.primaryDark,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Daily Tasks',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '3 of 8 completed',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Color.fromARGB(192, 253, 252, 255),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// PROGRESS
            CircularPercentIndicator(
              radius: 24,
              lineWidth: 5,

              percent: progress,

              animation: true,
              animateFromLastPercent: true,

              circularStrokeCap: CircularStrokeCap.round,

              progressColor: Colors.white,

              backgroundColor: Colors.white.withOpacity(.18),

              center: Text(
                '${progress * 100}%',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
