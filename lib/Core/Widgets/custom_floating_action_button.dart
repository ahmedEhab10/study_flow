import 'package:flutter/material.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key, this.onPressed});
  final void Function()? onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 4.0,
        focusElevation: 6.0,
        onPressed: onPressed,
        foregroundColor: ColorsManager.white,
        backgroundColor: ColorsManager.primaryDark,
        child: const Icon(Icons.add),
      ),
    );
  }
}
