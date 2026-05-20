import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';

class CompletedContainer extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onToggle;

  const CompletedContainer({super.key, required this.task, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            children: [
              SvgPicture.asset(Assets.svgsFillCompleteIcon),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
