import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/monthly_trend_chart.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_header.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/progress_stats_grid.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/time_by_subject_chart.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/time_summary_widget.dart';
import 'package:study_flow/features/My_Progress/Presentation/widgets/weekly_focus_chart.dart';
import 'package:study_flow/features/My_Progress/data/services/progress_analytics_service.dart';
import 'package:study_flow/features/My_Progress/domain/models/progress_stats.dart';

class ProgressBody extends StatefulWidget {
  const ProgressBody({super.key});

  @override
  State<ProgressBody> createState() => _ProgressBodyState();
}

class _ProgressBodyState extends State<ProgressBody> {
  final _analyticsService = ProgressAnalyticsService();
  late ProgressStats _stats;

  @override
  void initState() {
    super.initState();
    _stats = _analyticsService.calculate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh stats every time this screen comes back into view
    // (e.g. after user finishes a study session and navigates back)
    _loadStats();
  }

  void _loadStats() {
    setState(() => _stats = _analyticsService.calculate());
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 24.h;

    return RefreshIndicator(
      onRefresh: () async => _loadStats(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(child: ProgressHeader()),
          SliverToBoxAdapter(child: TimeSummaryWidget(stats: _stats)),
          SliverToBoxAdapter(child: ProgressStatsGrid(stats: _stats)),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(child: WeeklyFocusChart(stats: _stats)),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(child: TimeBySubjectChart(stats: _stats)),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(child: MonthlyTrendChart(stats: _stats)),
          SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
        ],
      ),
    );
  }
}
