import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/Core/Models/Study_Record_Model.dart';
import 'package:study_flow/features/Study_calendar/data/repositories/study_calendar_repository.dart';
import 'package:study_flow/features/Study_calendar/presentation/widgets/study_calendar_header.dart';
import 'package:study_flow/features/Study_calendar/presentation/widgets/study_stats_grid.dart';
import 'package:study_flow/features/Study_calendar/presentation/widgets/study_heatmap_calendar.dart';
import 'package:study_flow/features/Study_calendar/presentation/widgets/study_day_details_card.dart';

class StudyCalendarBody extends StatefulWidget {
  const StudyCalendarBody({super.key});

  @override
  State<StudyCalendarBody> createState() => _StudyCalendarBodyState();
}

class _StudyCalendarBodyState extends State<StudyCalendarBody>
    with RouteAware {
  final StudyCalendarRepository _repository = StudyCalendarRepository();
  List<StudyRecordModel> _records = [];
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _loadRecords();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload every time this screen comes back into view
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _records = _repository.getAllRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header (Back button, Title, Subtitle)
          const StudyCalendarHeader(),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadRecords(),
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  // Streaks & Stats Grid
                  StudyStatsGrid(records: _records),

                  // Monthly Heatmap Calendar
                  StudyHeatmapCalendar(
                    records: _records,
                    selectedDate: _selectedDate,
                    currentMonth: _currentMonth,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    onMonthChanged: (newMonth) {
                      setState(() {
                        _currentMonth = newMonth;
                      });
                    },
                  ),

                  // Daily Details Card
                  StudyDayDetailsCard(
                    selectedDate: _selectedDate,
                    records: _records,
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
