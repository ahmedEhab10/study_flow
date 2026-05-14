import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/MySubjectsSection.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_list.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/recent_active.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),

      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, Ahmed',
                  style: GoogleFonts.inter(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ready for today\'s session?',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF414751),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 10.h),
                InformationList(),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Subjects',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'View all',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),

                // Row(
                //   children: [
                //     SubjectItem(),
                //     Expanded(
                //       child: SubjectCard(
                //         subject: SubjectModel(
                //           name: 'Physics',
                //           subtitle: '8 PDFs',
                //           progress: 0.4,
                //           accent: ColorsManager.primaryDark,
                //           iconBg: ColorsManager.primary,
                //           icon: SubjectIcon.physics,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //
                SizedBox(height: 24.h),
                // SubjectItem(
                //   subject: SubjectModel(
                //     name: 'Physics',
                //     subtitle: '8 PDFs',
                //     progress: 0.4,
                //     accent: ColorsManager.primaryDark,
                //     iconBg: ColorsManager.primary,
                //     icon: SubjectIcon.physics,
                //   ),
                // ),
                MySubjectsSection(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                RecentActiveitem(),
                SizedBox(height: 8.h),
                RecentActiveitem(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



//ClipRRect(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   child: LinearProgressIndicator(
                //     value: 0.6,
                //     minHeight: 10, // Thickness of the bar
                //     color: Colors.green,
                //     backgroundColor: Colors.green.shade100,
                //   ),
                // ),