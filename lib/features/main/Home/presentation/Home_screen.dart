import 'package:flutter/material.dart';
import 'package:study_flow/Core/Widgets/custom_floatingactoinbutton.dart';

import 'package:study_flow/features/main/Home/presentation/widgets/Home_Screen_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingactoinbutton(onPressed: () {}),
      body: const SafeArea(child: HomeScreenBody()),
    );
  }
}
