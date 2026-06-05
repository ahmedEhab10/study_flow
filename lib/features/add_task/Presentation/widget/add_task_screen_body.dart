import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/Widgets/custom_elevated_button.dart';
import 'package:study_flow/Core/Widgets/custom_input_text_faild.dart';
import 'package:study_flow/Core/const/subject_list.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/add_task/Presentation/widget/reference_material.dart';
import 'package:study_flow/features/add_task/Presentation/widget/schedule_item.dart';
import 'package:study_flow/features/add_task/Presentation/widget/subject_name_item.dart';

class AddTaskScreenBody extends StatefulWidget {
  AddTaskScreenBody({super.key});
  int selectedSubject = 0;

  @override
  State<AddTaskScreenBody> createState() => _AddTaskScreenBodyState();
}

class _AddTaskScreenBodyState extends State<AddTaskScreenBody> {
  @override
  Widget build(BuildContext context) {
    final displayedSubjects = subjectsNamelist.length > 5
        ? subjectsNamelist.sublist(subjectsNamelist.length - 5)
        : subjectsNamelist;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomScrollPadding = 75.0 + MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'What do you need to study?',
                  style: GoogleFonts.inter(
                    color: ColorsManager.textSecondaryLight,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Subjects',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 45,

                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,

                    itemCount: displayedSubjects.length + 1,

                    separatorBuilder: (_, __) => const SizedBox(width: 12),

                    itemBuilder: (context, index) {
                      // زرار + New
                      if (index == displayedSubjects.length) {
                        return GestureDetector(
                          onTap: () {},
                          child: SubjectNameItem(title: '+ New'),
                        );
                      }

                      final subject = displayedSubjects[index];

                      final isSelected = widget.selectedSubject == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedSubject = index;
                          });
                        },
                        child: SubjectNameItem(
                          title: subject,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Details',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomInputTextFaild(
                  maxLines: 4,
                  hint: 'Add page numbers, specific topics, or notes...',
                  accent: theme.colorScheme.surface,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reference Material',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/Svgs/attatchment.svg'),
                        const SizedBox(width: 4),
                        Text(
                          'Add',
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorsManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 80.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return const ReferenceMaterial();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ScheduleItem(
                        title: 'Today',
                        icon: Assets.svgsTodayIcon,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ScheduleItem(
                        title: 'Tomorrow',
                        icon: Assets.svgsTommrowIcon,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ScheduleItem(
                        title: 'Custom',
                        icon: Assets.svgsCustomTimeIcon,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: ShapeDecoration(
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0x19717783),
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(Assets.svgsTimeGrayIcon),
                          const SizedBox(width: 8),
                          Text(
                            'Time',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 36.69.h,
                        width: 96.w,
                        color: Color.fromARGB(62, 0, 92, 167),
                        child: Center(
                          child: Text(
                            '9:00 AM',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                CustomElevatedButton(onPressed: () {}, title: 'Create Task'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



// ChoiceChip(
//                         disabledColor: isDark
//                             ? const Color(0xff2E3038)
//                             : const Color(0xffEDEDF7),

//                         labelPadding: const EdgeInsets.symmetric(
//                           vertical: 4,
//                           horizontal: 2,
//                         ),

//                         labelStyle: GoogleFonts.inter(
//                           color: isDark
//                               ? ColorsManager.white
//                               : const Color(0xff414751),

//                           fontSize: 12.sp,

//                           fontWeight: FontWeight.bold,
//                         ),

//                         label: Text(subject),

//                         selected: isSelected,

//                         showCheckmark: true,

//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),

//                         onSelected: (_) {
//                           // setState(() {
//                           //   selectedSubject = subject;
//                           // });
//                         },
//                       );