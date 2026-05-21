import 'package:flutter/material.dart';
import 'package:study_flow/Core/Widgets/custom_floating_action_button.dart';
import 'package:study_flow/features/main/Home/presentation/widgets/Home_Screen_body.dart';
import 'package:study_flow/Core/Widgets/Show_Modern_Bottom_Sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          showModernBottomSheet(context);
        },
      ),
      body: const SafeArea(child: HomeScreenBody()),
    );
  }
}
