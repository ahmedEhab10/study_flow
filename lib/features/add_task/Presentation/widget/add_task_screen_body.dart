import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_flow/Core/Models/Pdf_Model.dart';
import 'package:study_flow/Core/Models/Task_Model.dart';
import 'package:study_flow/Core/Utils/app_assets.dart';
import 'package:study_flow/Core/Widgets/custom_elevated_button.dart';
import 'package:study_flow/Core/Widgets/custom_input_text_faild.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';
import 'package:study_flow/features/main/Home/presentation/cubit/subjects_cubit.dart';
import 'package:study_flow/features/main/Tasks/presentation/cubit/tasks_cubit.dart';
import 'package:study_flow/features/add_task/Presentation/widget/reference_material.dart';
import 'package:study_flow/features/add_task/Presentation/widget/schedule_item.dart';
import 'package:study_flow/features/add_task/Presentation/widget/subject_name_item.dart';

class AddTaskScreenBody extends StatefulWidget {
  const AddTaskScreenBody({super.key});

  @override
  State<AddTaskScreenBody> createState() => _AddTaskScreenBodyState();
}

class _AddTaskScreenBodyState extends State<AddTaskScreenBody> {
  final _detailsController = TextEditingController();

  final List<String> _subjectNames = [];
  String? _selectedSubjectName;
  int? _selectedPdfIndex;
  String _selectedSchedule =
      'today'; // 'today', 'tomorrow', or custom date string
  DateTime? _customDueDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final subjects = context.read<SubjectsCubit>().state.subjects;
      for (var subject in subjects) {
        if (!_subjectNames.contains(subject.name)) {
          _subjectNames.add(subject.name);
        }
      }
      if (_subjectNames.isNotEmpty) {
        _selectedSubjectName = _subjectNames.first;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorsManager.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _selectCustomDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorsManager.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _customDueDate = date;
        _selectedSchedule = _formatDate(date);
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickAndUploadPdf() async {
    if (_selectedSubjectName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a subject first',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size <= 25 * 1024 * 1024) {
          if (file.path != null) {
            final appDir = await getApplicationDocumentsDirectory();
            final pdfsDir = Directory('${appDir.path}/pdfs');
            if (!await pdfsDir.exists()) {
              await pdfsDir.create(recursive: true);
            }

            final originalFile = File(file.path!);
            final uniqueName =
                '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
            final targetPath = '${pdfsDir.path}/$uniqueName';
            await originalFile.copy(targetPath);

            final pdf = PdfModel(
              title: file.name,
              subjectName: _selectedSubjectName!,
              timeAgo: 'Opened just now',
              filePath: targetPath,
            );

            if (mounted) {
              context.read<SubjectsCubit>().addPdfToSubject(
                _selectedSubjectName!,
                pdf,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'File size exceeds the 25MB limit.',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking/uploading PDF: $e');
    }
  }

  void _addNewSubjectName() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'New Subject Name',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. History',
              hintStyle: GoogleFonts.inter(fontSize: 14.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: ColorsManager.textSecondaryLight,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    if (!_subjectNames.contains(name)) {
                      _subjectNames.add(name);
                    }
                    _selectedSubjectName = name;
                  });
                  Navigator.of(context).pop();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: ColorsManager.primary,
              ),
              child: Text('Add', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _createTask(List<dynamic> recentPdfs) {
    final details = _detailsController.text.trim();
    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter task details',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedSubjectName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a subject',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final selectedPdf = _selectedPdfIndex != null
        ? recentPdfs[_selectedPdfIndex!]
        : null;

    final task = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title:
          details, // Store details in title to preserve old format & expandable description
      subjectName: _selectedSubjectName!,
      pdfTitle: selectedPdf?.title,
      isCompleted: false,
      dueCategory: _selectedSchedule,
      taskTime: _selectedTime.format(context),
    );

    context.read<TasksCubit>().addTask(task);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomScrollPadding =
        75.0 + MediaQuery.paddingOf(context).bottom + 24.h;

    // Load actual subjects to populate recent PDFs list
    final subjects = context.watch<SubjectsCubit>().state.subjects;

    // Last 5 subjects in the displayed names list
    final displayedSubjectNames = _subjectNames.length > 5
        ? _subjectNames.sublist(_subjectNames.length - 5)
        : _subjectNames;

    // Dynamic Recent PDFs (last 3)
    final allPdfs = subjects.expand((s) => s.pdfs).toList();
    final recentPdfs = allPdfs.reversed.take(3).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'What do you need to study?',
                  style: GoogleFonts.inter(
                    color: ColorsManager.textSecondaryLight,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 24.h),

                // Subjects section
                Text(
                  'Subjects',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 45,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayedSubjectNames.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == displayedSubjectNames.length) {
                        return GestureDetector(
                          onTap: _addNewSubjectName,
                          child: const SubjectNameItem(title: '+ New'),
                        );
                      }

                      final subjectName = displayedSubjectNames[index];
                      final isSelected = _selectedSubjectName == subjectName;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSubjectName = subjectName;
                          });
                        },
                        child: SubjectNameItem(
                          title: subjectName,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // Details section
                Text(
                  'Details',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomInputTextFaild(
                  controller: _detailsController,
                  maxLines: 4,
                  hint: 'Add page numbers, specific topics, or notes...',
                  accent: theme.colorScheme.surface,
                ),
                const SizedBox(height: 24),

                // Reference Material section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reference Material',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickAndUploadPdf,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/Svgs/attatchment.svg'),
                          const SizedBox(width: 4),
                          Text(
                            'Add',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsManager.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (recentPdfs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.5,
                          color: Color(0x19717783),
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'No recent PDFs found.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recentPdfs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final pdf = recentPdfs[index];
                        final isSelected = _selectedPdfIndex == index;

                        return ReferenceMaterial(
                          pdf: pdf,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedPdfIndex = isSelected ? null : index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),

                // Schedule section
                Text(
                  'Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSchedule = 'today';
                            _customDueDate = null;
                          });
                        },
                        child: ScheduleItem(
                          title: 'Today',
                          icon: Assets.svgsTodayIcon,
                          isSelected: _selectedSchedule == 'today',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSchedule = 'tomorrow';
                            _customDueDate = null;
                          });
                        },
                        child: ScheduleItem(
                          title: 'Tomorrow',
                          icon: Assets.svgsTodayIcon,
                          isSelected: _selectedSchedule == 'tomorrow',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectCustomDate,
                        child: ScheduleItem(
                          title: _customDueDate != null
                              ? _formatDate(_customDueDate!)
                              : 'Custom',
                          icon: Assets.svgsCustomTimeIcon,
                          isSelected:
                              _selectedSchedule != 'today' &&
                              _selectedSchedule != 'tomorrow',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Time picker row
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.5,
                          color: Color(0x19717783),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(Assets.svgsTimeGrayIcon),
                            const SizedBox(width: 8),
                            Text(
                              'Time',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 36.69.h,
                          width: 96.w,
                          color: const Color.fromARGB(62, 0, 92, 167),
                          child: Center(
                            child: Text(
                              _selectedTime.format(context),
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorsManager.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                CustomElevatedButton(
                  onPressed: () => _createTask(recentPdfs),
                  title: 'Create Task',
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
      ],
    );
  }
}
