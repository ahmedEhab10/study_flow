import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/SubjectColor.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart' as subject_model;
import 'package:study_flow/Core/Helper/subject_icon_pranter.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class _SubjectIconOption {
  final subject_model.SubjectIcon icon;
  final String label;

  const _SubjectIconOption({required this.icon, required this.label});
}

class AddSubjectSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String inputLabel;
  final String inputHint;
  final String ctaLabel;
  final Future<void> Function(
    String name,
    Color accent,
    subject_model.SubjectIcon icon,
    List<PlatformFile> pdfFiles,
  )?
  onSubmit;

  const AddSubjectSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.inputLabel,
    required this.inputHint,
    required this.ctaLabel,
    this.onSubmit,
  });

  @override
  State<AddSubjectSheet> createState() => _AddSubjectSheetState();
}

class _AddSubjectSheetState extends State<AddSubjectSheet> {
  final _controller = TextEditingController();
  int _selectedColor = 0;
  int _selectedIcon = 0;
  final List<PlatformFile> _selectedFiles = [];
  bool _submitting = false;

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );
      if (result != null) {
        final List<PlatformFile> validFiles = [];
        for (var file in result.files) {
          if (file.size <= 25 * 1024 * 1024) {
            validFiles.add(file);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${file.name}" exceeds the 25MB size limit.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        }
        setState(() {
          _selectedFiles.addAll(validFiles);
        });
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  static const _colors = [
    SubjectColor(color: Color(0xFF2563EB), label: 'Blue'),
    SubjectColor(color: Color(0xFF7C3AED), label: 'Purple'),
    SubjectColor(color: Color(0xFF059669), label: 'Green'),
    SubjectColor(color: Color(0xFFF59E0B), label: 'Amber'),
    SubjectColor(color: Color(0xFFE11D48), label: 'Rose'),
  ];

  static const _icons = [
    _SubjectIconOption(
      icon: subject_model.SubjectIcon.general,
      label: 'General',
    ),
    _SubjectIconOption(
      icon: subject_model.SubjectIcon.biology,
      label: 'Biology',
    ),
    _SubjectIconOption(
      icon: subject_model.SubjectIcon.physics,
      label: 'Physics',
    ),

    _SubjectIconOption(
      icon: subject_model.SubjectIcon.mathematics,
      label: 'Mathematics',
    ),
    _SubjectIconOption(
      icon: subject_model.SubjectIcon.chemistry,
      label: 'Chemistry',
    ),
    _SubjectIconOption(
      icon: subject_model.SubjectIcon.literature,
      label: 'Literature',
    ),

    _SubjectIconOption(
      icon: subject_model.SubjectIcon.computerScience,
      label: 'Computer Science',
    ),
  ];

  Color get _accent => _colors[_selectedColor].color;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a subject name'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    if (widget.onSubmit != null) {
      await widget.onSubmit!(
        value,
        _accent,
        _icons[_selectedIcon].icon,
        _selectedFiles,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
                // ── Drag handle
                const _DragHandle(),

                // ── Header
                _SheetHeader(title: widget.title, subtitle: widget.subtitle),

                const SizedBox(height: 12),

                // ── Text input widget
                _SectionLabel(widget.inputLabel),
                _TextInputWidget(
                  controller: _controller,
                  hint: widget.inputHint,
                  accent: _accent,
                ),
                SizedBox(height: 12),

                // ── Color picker widget
                const _SectionLabel('Accent Color'),
                _ColorPickerWidget(
                  colors: _colors,
                  selected: _selectedColor,
                  onChanged: (i) => setState(() => _selectedColor = i),
                ),

                // ── Icon picker widget
                const _SectionLabel('Subject Icon'),
                _IconPickerWidget(
                  icons: _icons,
                  selected: _selectedIcon,
                  accent: _accent,
                  onChanged: (i) => setState(() => _selectedIcon = i),
                ),

                // ── Upload widget
                const _SectionLabel('Study Materials'),
                _UploadWidget(onTap: _pickFiles),

                // ── Selected files list
                if (_selectedFiles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      children: _selectedFiles.map((file) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.picture_as_pdf_rounded,
                                color: _accent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  file.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _selectedFiles.remove(file);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // ── CTA widget
                if (_submitting)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Center(
                      child: CircularProgressIndicator(color: _accent),
                    ),
                  )
                else
                  _CtaWidget(
                    label: widget.ctaLabel,
                    accent: _accent,
                    onTap: _handleSubmit,
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SMALL WIDGETS
// ─────────────────────────────────────────────

/// Drag handle pill at the top of the sheet.
class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 4),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: ColorsManager.textSecondaryLight,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}

/// Sheet title + subtitle + close button row.
class _SheetHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SheetHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase section label — reused across all sections.
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET 1 — Text input
// ─────────────────────────────────────────────
///
/// Reusable text field. Swap [hint] and [controller] for different use-cases
/// (course name, description, etc.). For multi-line, set [maxLines] > 1.
///
class _TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color accent;

  const _TextInputWidget({
    required this.controller,
    required this.hint,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: accent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET 2 — Color picker
// ─────────────────────────────────────────────

class _ColorPickerWidget extends StatelessWidget {
  final List<SubjectColor> colors;
  final int selected;
  final ValueChanged<int> onChanged;

  const _ColorPickerWidget({
    required this.colors,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(colors.length, (i) {
          final isSelected = i == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors[i].color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colors[i].color.withValues(alpha: 0.5),
                            blurRadius: 0,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET 3 — Icon picker
// ─────────────────────────────────────────────

class _IconPickerWidget extends StatelessWidget {
  final List<_SubjectIconOption> icons;
  final int selected;
  final Color accent;
  final ValueChanged<int> onChanged;

  const _IconPickerWidget({
    required this.icons,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(icons.length, (i) {
            final isSelected = i == selected;
            return Padding(
              padding: EdgeInsets.only(right: i == icons.length - 1 ? 0 : 8),
              child: Tooltip(
                message: icons[i].label,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? accent
                            : Theme.of(context).colorScheme.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: SubjectIconWidget(
                        icon: icons[i].icon,
                        color: isSelected ? Colors.white : accent,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET 4 — Upload zone
// ─────────────────────────────────────────────

class _UploadWidget extends StatefulWidget {
  final VoidCallback onTap;
  const _UploadWidget({required this.onTap});

  @override
  State<_UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<_UploadWidget> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            height: 192.h,
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(1.5),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),

            child: DottedBorder(
              options: RectDottedBorderOptions(
                dashPattern: [10, 5],
                strokeWidth: 2,
                padding: EdgeInsets.all(16),
                color: _hovering
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary,
              ),

              // radius: const Radius.circular(12),

              // dashPattern: const [6, 4],

              // strokeWidth: 1.5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Browse files to upload',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Supports PDF, DOCX (Max 25MB)',
                      style: GoogleFonts.inter(
                        color: ColorsManager.textSecondaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET 5 — CTA button
// ─────────────────────────────────────────────

class _CtaWidget extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _CtaWidget({
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: ColorsManager.primaryDark,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        iconAlignment: IconAlignment.end,
        label: Text(label),
      ),
    );
  }
}
