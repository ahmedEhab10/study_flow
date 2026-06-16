import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class TaskContainer extends StatefulWidget {
  final TaskModel task;
  final ValueChanged<bool?>? onChanged;

  const TaskContainer({
    super.key,
    required this.task,
    this.onChanged,
  });

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    focusColor: ColorsManager.primaryDark,
                    checkColor: ColorsManager.white,
                    activeColor: ColorsManager.primaryDark,
                    value: widget.task.isCompleted,
                    onChanged: widget.onChanged,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task title (which is details text) - Expandable
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.task.title,
                              maxLines: _isExpanded ? null : 1,
                              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20.r,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    if (_isExpanded && widget.task.taskTime != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.r,
                            color: ColorsManager.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.task.taskTime!,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsManager.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            widget.task.subjectName,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff22C55E),
                            ),
                          ),
                        ),
                        if (widget.task.pdfTitle != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/Svgs/pdf_blue_icon.svg'),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.task.pdfTitle!,
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
      ),
    );
  }
}
