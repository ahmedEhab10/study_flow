import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Widgets/custom_elevated_button.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/Onboarding/Presentation/Widgets/onboarding_screen_one.dart';
import 'package:study_flow/features/Onboarding/Presentation/Widgets/onboarding_screen_three.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,

          controller: controller,
          children: [
            OnboardingScreenOne(),
            OnboardingScreenTwo(),
            OnboardingScreenThree(),
          ],
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              children: [
                DotsIndicator(
                  dotsCount: 3,
                  position: currentIndex.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: ColorsManager.primaryDark,
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    if (currentIndex < 2) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.main_layout,
                      );
                    }
                  },
                  title: currentIndex == 2 ? 'Get Started' : 'Next',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
