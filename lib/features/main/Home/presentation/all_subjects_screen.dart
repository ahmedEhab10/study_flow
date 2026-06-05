import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Widgets/custom_app_bar.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/subject_item.dart';

class AllSubjectsScreen extends StatelessWidget {
  const AllSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch SubjectsCubit to rebuild reactively when new subjects are added
    final subjects = context.watch<SubjectsCubit>().state.subjects;

    return Scaffold(
      appBar: customAppBar(title: 'All Subjects', context: context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14.h,
            crossAxisSpacing: 14.w,
            mainAxisExtent: 220.h,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return SubjectItem(
              subject: subject,
              isLarge: false,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.subject_screen,
                  arguments: subject,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
