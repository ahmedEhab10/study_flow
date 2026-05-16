import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class TaskContinar extends StatefulWidget {
  const TaskContinar({super.key});

  @override
  State<TaskContinar> createState() => _TaskContinarState();
}

class _TaskContinarState extends State<TaskContinar> {
  bool isChecked = false;
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
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                focusColor: ColorsManager.primaryDark,
                checkColor: ColorsManager.white,
                activeColor: ColorsManager.primaryDark,

                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                shape: CircleBorder(side: BorderSide(width: 5.w)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Cell Biology Notes',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(118, 34, 197, 94),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Biology',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        SvgPicture.asset('assets/Svgs/pdf_blue_icon.svg'),
                        const SizedBox(width: 6),
                        Text(
                          'Cell_Basics.pdf',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorsManager.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
