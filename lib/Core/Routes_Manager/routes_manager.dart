import 'package:flutter/material.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/features/Onboarding/Presentation/onboarding_screen.dart';
import 'package:study_flow/features/Splash/presentation/splash_screen.dart';
import 'package:study_flow/features/subject_details/presentation/subject_details_screen.dart';
import 'package:study_flow/features/main/main_layout.dart';

abstract class RoutesManager {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (context) => const OnboardingScreen());
      case Routes.main_layout:
        return MaterialPageRoute(builder: (context) => const MainLayout());
      case Routes.subject_screen:
        final subject = settings.arguments as SubjectModel;
        return MaterialPageRoute(
          builder: (context) => SubjectDetailsScreen(subject: subject),
        );
      default:
        return null;
    }
  }
}
