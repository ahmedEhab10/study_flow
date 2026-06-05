import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_flow/Core/Provider/Theme_provider.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Routes_Manager/routes_manager.dart';
import 'package:study_flow/config/theme/Theme_Manager.dart';
import 'package:study_flow/Core/Services/hive_service.dart';
import 'package:study_flow/features/main/Home/data/repositories/subject_repository_impl.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasks_box');
  await Hive.openBox('subjects_box');

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksCubit>(create: (_) => TasksCubit()),
        BlocProvider<SubjectsCubit>(
          create: (_) => SubjectsCubit(
            SubjectRepositoryImpl(HiveService()),
          ),
        ),
      ],
      child: ScreenUtilInit(
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
      ),
    );
  }
}
