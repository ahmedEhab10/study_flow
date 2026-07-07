import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Services/user_prefs_service.dart';
import 'package:study_flow/Core/Widgets/view_all_row.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/MySubjectsSection.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/information_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/Core/Widgets/pdf_item.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final profile = await UserPrefsService.getUserProfile();
    if (!mounted) return;
    setState(() {
      _userName = (profile['name'] as String?) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomScrollPadding =
        75.0 + MediaQuery.paddingOf(context).bottom + 24.h;

    final subjects = context.watch<SubjectsCubit>().state.subjects;
    final allPdfs = subjects.expand((s) => s.pdfs).toList();
    // Gather all PDFs and reverse to show the most recent first
    final recentPdfs = allPdfs.reversed.take(3).toList();

    // Build greeting: "Welcome back, Ahmed!" or "Welcome back!" if no name yet
    final greeting = _userName.isNotEmpty
        ? 'Welcome back, $_userName!'
        : 'Welcome back!';

    if (subjects.isEmpty) {
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
                    greeting,
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
                  Divider(height: 10, color: Colors.grey.shade300),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
                ],
              ),
            ),
          ),

          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      'assets/animation/No_task_result.json',
                      width: 200.r,
                      height: 200.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No subjects yet!',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        'Add study subjects to store your materials, take notes, and track your daily sessions.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ),
                    Spacer(),
                    Divider(height: 10, color: Colors.grey.shade300),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
        ],
      );
    }

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
                  greeting,
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
                const SizedBox(height: 8),
                if (recentPdfs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'No recent PDFs uploaded yet.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  ...recentPdfs.map(
                    (pdf) => Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: PdfItem(pdf: pdf),
                    ),
                  ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
      ],
    );
  }
}
