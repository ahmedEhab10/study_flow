import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Widgets/view_all_row.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/MySubjectsSection.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_list.dart';
import 'package:study_flow/Core/Widgets/pdf_item.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomScrollPadding =
        75.0 + MediaQuery.paddingOf(context).bottom + 24.h;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),

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
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 10.h),
                InformationList(),
                SizedBox(height: 24.h),

                // view all item is here
                ViewAllRow(
                  title: 'My Subjects',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.all_subjects);
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          sliver: const MySubjectsSection(),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 32.h)),

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
                const PdfItem(),
                SizedBox(height: 6.h),
                const PdfItem(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
      ],
    );
  }
}


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


//ClipRRect(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   child: LinearProgressIndicator(
                //     value: 0.6,
                //     minHeight: 10, // Thickness of the bar
                //     color: Colors.green,
                //     backgroundColor: Colors.green.shade100,
                //   ),
                // ),
