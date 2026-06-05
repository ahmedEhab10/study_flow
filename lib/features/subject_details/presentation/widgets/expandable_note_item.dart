import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Note_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class ExpandableNoteItem extends StatefulWidget {
  final NoteModel note;
  final bool isProgressMode;
  final ValueChanged<bool>? onCompletionToggled;

  const ExpandableNoteItem({
    super.key,
    required this.note,
    this.isProgressMode = false,
    this.onCompletionToggled,
  });

  @override
  State<ExpandableNoteItem> createState() => _ExpandableNoteItemState();
}

class _ExpandableNoteItemState extends State<ExpandableNoteItem> {
  bool _isExpanded = false;

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
          color: widget.note.isCompleted
              ? (isDark
                  ? ColorsManager.primary.withValues(alpha: 0.08)
                  : ColorsManager.primary.withValues(alpha: 0.04))
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: widget.note.isCompleted
                  ? ColorsManager.primary.withValues(alpha: 0.35)
                  : const Color(0x19717783),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress-mode checkbox
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: widget.isProgressMode
                  ? Padding(
                      padding: EdgeInsets.only(right: 8.w, top: 2.h),
                      child: SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: Checkbox(
                          value: widget.note.isCompleted,
                          onChanged: (val) =>
                              widget.onCompletionToggled?.call(val ?? false),
                          activeColor: ColorsManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Content area
            Expanded(
              child: GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.note.isCompleted
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                : theme.colorScheme.onSurface,
                            decoration: widget.note.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Chevron icon (rotates on expand)
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20.r,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        Assets.svgsNoteIitemCon,
                        width: 20.r,
                        height: 20.r,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Animated content body
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.note.content,
                      maxLines: _isExpanded ? null : 2,
                      overflow:
                          _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),

                  // Date chip shown when expanded
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: _isExpanded
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12.r,
                                  color: ColorsManager.primary.withValues(alpha: 0.7),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _formatDate(widget.note.dateCreated),
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsManager.primary.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
