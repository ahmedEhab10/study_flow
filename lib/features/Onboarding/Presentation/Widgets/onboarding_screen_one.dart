import 'package:flutter/material.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.imagesOnboardinImage1, fit: BoxFit.cover),
          Text(
            'Organize Your Study Life',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Store and organize all your study PDFs and\nsubjects in one clean place.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorsManager.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
