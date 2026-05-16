import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/Core/resources/ConstanstManager.dart';
import 'package:study_flow/features/main/Home/presentation/Home_screen.dart';
import 'package:study_flow/features/main/Profile/presentation/profile_screen.dart';
import 'package:study_flow/features/main/Tasks/presentation/Tasks_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> screens = const [
    HomeScreen(key: ValueKey(0)),
    TasksScreen(key: ValueKey(1)),
    ProfileScreen(key: ValueKey(2)),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          /// ✅ Animated Screens
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0), // حركة جانبية بسيطة
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: screens[currentIndex],
            ),
          ),

          /// ✅ Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? ColorsManager.black : ColorsManager.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: AnimatedScale(
                      scale: currentIndex == index ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: SvgPicture.asset(
                        Constanstmanager.navbaritems[index],
                        colorFilter: ColorFilter.mode(
                          currentIndex == index
                              ? ColorsManager.primaryDark
                              : ColorsManager.gray,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
