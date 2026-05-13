import 'package:flutter/cupertino.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/features/Onboarding/Presentation/onboarding_screen.dart';
import 'package:study_flow/features/Splash/presentation/splash_screen.dart';
import 'package:study_flow/features/main/main_layout.dart';

class RoutesManager {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (context) => SplashScreen());

      case Routes.onboarding:
        return CupertinoPageRoute(builder: (context) => OnboardingScreen());

      case Routes.main_layout:
        return CupertinoPageRoute(builder: (context) => const MainLayout());

      default:
        return null;
    }
  }
}
