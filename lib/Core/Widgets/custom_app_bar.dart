import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppBar({required String title, required BuildContext context}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: theme.colorScheme.onSurface,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
