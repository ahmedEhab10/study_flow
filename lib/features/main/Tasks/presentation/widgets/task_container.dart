import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class TaskContainer extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<bool?>? onChanged;

  const TaskContainer({
    super.key,
    required this.task,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 2,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                focusColor: ColorsManager.primaryDark,
                checkColor: ColorsManager.white,
                activeColor: ColorsManager.primaryDark,
                value: task.isCompleted,
                onChanged: onChanged,
                shape: const CircleBorder(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(40, 34, 197, 94),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          task.subjectName,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff22C55E),
                          ),
                        ),
                      ),
                      if (task.pdfTitle != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/Svgs/pdf_blue_icon.svg'),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  task.pdfTitle!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsManager.primaryDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
