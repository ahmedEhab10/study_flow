import 'package:flutter/material.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(Assets.imagesOnboardinImage3, fit: BoxFit.cover),
        Text(
          'AI-Powered Quiz Generation',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Upload PDFs and instantly generate\nsmart quizzes powered by AI.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorsManager.gray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
