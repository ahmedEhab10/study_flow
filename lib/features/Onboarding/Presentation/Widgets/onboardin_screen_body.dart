import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Widgets/custom_elevated_button.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/Onboarding/Presentation/Widgets/onboarding_screen_one.dart';
import 'package:study_flow/features/Onboarding/Presentation/Widgets/onboarding_screen_two.dart';

class OnboardinScreenBody extends StatefulWidget {
  const OnboardinScreenBody({super.key});

  @override
  State<OnboardinScreenBody> createState() => _OnboardinScreenBodyState();
}

class _OnboardinScreenBodyState extends State<OnboardinScreenBody> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _goToSetup() {
    Navigator.pushReplacementNamed(context, Routes.setup);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = currentIndex == 1;

    return Stack(
      children: [
        // ── Page content ───────────────────────────────────────────
        PageView(
          onPageChanged: (index) => setState(() => currentIndex = index),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: const [
            OnboardingScreenOne(),
            OnboardingScreenTwo(),
          ],
        ),

        // ── Skip button (top-right) ────────────────────────────────
        Positioned(
          top: 12.h,
          right: 16.w,
          child: AnimatedOpacity(
            opacity: isLast ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: SafeArea(
              child: GestureDetector(
                onTap: isLast ? null : _goToSetup,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Bottom nav (dots + button) ─────────────────────────────
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Column(
              children: [
                DotsIndicator(
                  dotsCount: 2,
                  position: currentIndex.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: ColorsManager.primaryDark,
                    color: ColorsManager.primaryDark.withValues(alpha: 0.25),
                    size: const Size.square(8.0),
                    activeSize: const Size(22.0, 8.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                CustomElevatedButton(
                  onPressed: () {
                    if (currentIndex < 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOutCubic,
                      );
                    } else {
                      _goToSetup();
                    }
                  },
                  title: isLast ? 'Get Started' : 'Next',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
