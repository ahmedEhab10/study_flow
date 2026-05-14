import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Routes_Manager/routes_manager.dart';

void main() {
  runApp(const StudyFlow());
}

class StudyFlow extends StatelessWidget {
  const StudyFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(443, 800),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 246, 245, 247),
        ),
        onGenerateRoute: RoutesManager.onGenerateRoute,
        initialRoute: Routes.splash,
      ),
    );
  }
}
