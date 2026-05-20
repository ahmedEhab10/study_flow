import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_flow/Core/Provider/Theme_provider.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Routes_Manager/routes_manager.dart';
import 'package:study_flow/config/theme/Theme_Manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const StudyFlow(),
    ),
  );
}

class StudyFlow extends StatelessWidget {
  const StudyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(443, 881),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        // Watch ThemeProvider so MaterialApp rebuilds whenever the theme changes
        final themeMode = context.watch<ThemeProvider>().themeMode;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'StudyFlow',
          theme: ThemeManager.light,
          darkTheme: ThemeManager.dark,
          themeMode: themeMode,
          onGenerateRoute: RoutesManager.onGenerateRoute,
          initialRoute: Routes.splash,
        );
      },
    );
  }
}
