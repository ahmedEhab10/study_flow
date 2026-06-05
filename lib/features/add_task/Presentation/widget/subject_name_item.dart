import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectNameItem extends StatelessWidget {
  const SubjectNameItem({
    super.key,
    required this.title,
    this.isSelected = false,
  });
  final String title;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected
            ? Colors.green
            : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0x4CC1C7D3)),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.white : const Color(0xFF414751)),
          fontSize: 16,

          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
