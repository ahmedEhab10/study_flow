import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Models/Subject_Model.dart';
import 'package:study_flow/Core/Services/study_timer_service.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

// ── Motivational quotes ────────────────────────────────────────────────────────
const List<Map<String, String>> _quotes = [
  {
    'text':
        '"The beautiful thing about learning is that nobody can take it away from you."',
    'author': '— B.B. King',
  },
  {
    'text':
        '"Education is the most powerful weapon which you can use to change the world."',
    'author': '— Nelson Mandela',
  },
  {
    'text': '"The more that you read, the more things you will know."',
    'author': '— Dr. Seuss',
  },
  {
    'text': '"An investment in knowledge pays the best interest."',
    'author': '— Benjamin Franklin',
  },
  {
    'text':
        '"Success is the sum of small efforts, repeated day in and day out."',
    'author': '— Robert Collier',
  },
  {
    'text': '"The secret of getting ahead is getting started."',
    'author': '— Mark Twain',
  },
];

// ── Preset goal options ────────────────────────────────────────────────────────
const List<_GoalPreset> _goalPresets = [
  _GoalPreset(label: '30m', seconds: 30 * 60),
  _GoalPreset(label: '1h', seconds: 60 * 60),
  _GoalPreset(label: '1.5h', seconds: 90 * 60),
  _GoalPreset(label: '2h', seconds: 120 * 60),
  _GoalPreset(label: '3h', seconds: 180 * 60),
];

class _GoalPreset {
  final String label;
  final int seconds;
  const _GoalPreset({required this.label, required this.seconds});
}

// ══════════════════════════════════════════════════════════════════════════════
class StudySessionScreen extends StatefulWidget {
  final SubjectModel subject;
  const StudySessionScreen({super.key, required this.subject});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends State<StudySessionScreen>
    with TickerProviderStateMixin {
  late final StudyTimerService _timerService;
  late final Map<String, String> _quote;

  // ── Animation controllers ──────────────────────────────────────────────────
  /// Slow rotation for the outer dashed ring
  late final AnimationController _rotateController;
  /// Breathing pulse for ring opacity/scale
  late final AnimationController _pulseController;
  /// Ripple expand for the outermost decorative ring
  late final AnimationController _rippleController;

  late final Animation<double> _pulseAnim;
  late final Animation<double> _rippleAnim;

  @override
  void initState() {
    super.initState();
    _timerService = StudyTimerService();
    _quote = _quotes[math.Random().nextInt(_quotes.length)];

    // Continuous slow rotation (20 s / full turn)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Breathing pulse (2 s)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Outward ripple (3 s, looping)
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Start a fresh session only if none is active for this subject
    if (!_timerService.hasActiveSession ||
        _timerService.currentSubject != widget.subject.name) {
      _timerService.start(subjectName: widget.subject.name);
    }

    _timerService.addListener(_onTimerChanged);
  }

  void _onTimerChanged() {
    if (!mounted) return;
    // Pause/resume ring animations with the timer
    if (_timerService.isRunning) {
      if (!_rotateController.isAnimating) _rotateController.repeat();
      if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
      if (!_rippleController.isAnimating) _rippleController.repeat();
    } else {
      _rotateController.stop();
      _pulseController.stop();
      _rippleController.stop();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timerService.removeListener(_onTimerChanged);
    _rotateController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  // ── Goal picker ────────────────────────────────────────────────────────────
  void _showGoalPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoalPickerSheet(
        currentGoalSeconds: _timerService.goalSeconds,
        onGoalSelected: (seconds) {
          _timerService.setGoal(seconds);
          setState(() {});
        },
      ),
    );
  }

  // ── Finish ─────────────────────────────────────────────────────────────────
  void _onFinish() {
    final elapsed = _timerService.elapsedSeconds;
    _timerService.stop();
    if (mounted) _showFinishDialog(elapsed);
  }

  void _showFinishDialog(int elapsed) {
    final h = elapsed ~/ 3600;
    final m = (elapsed % 3600) ~/ 60;
    final s = elapsed % 60;
    final formatted =
        h > 0 ? '${h}h ${m}m' : m > 0 ? '${m}m ${s}s' : '${s}s';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8.w),
            Text('Session Complete!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          'Great work! You studied ${widget.subject.name} for $formatted.',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: GoogleFonts.inter(
                color: ColorsManager.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRunning = _timerService.isRunning;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {},
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                _buildCircularTimer(isRunning, isDark),
                SizedBox(height: 28.h),
                _buildProgressSection(isDark),
                SizedBox(height: 28.h),
                _buildControls(isRunning, isDark),
                SizedBox(height: 24.h),
                _buildDailyOverview(theme, isDark),
                SizedBox(height: 16.h),
                _buildQuoteCard(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            size: 20.r, color: theme.colorScheme.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: widget.subject.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              widget.subject.name,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: widget.subject.accent,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            widget.subject.subtitle.isNotEmpty
                ? widget.subject.subtitle
                : widget.subject.name,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        // Goal picker trigger
        Tooltip(
          message: 'Set Study Goal',
          child: GestureDetector(
            onTap: _showGoalPicker,
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: ColorsManager.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: ColorsManager.primary.withValues(alpha: 0.20),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.flag_rounded,
                size: 18.r,
                color: ColorsManager.primaryDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Circular Timer with animated rings ────────────────────────────────────
  Widget _buildCircularTimer(bool isRunning, bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_rotateController, _pulseController, _rippleController]),
      builder: (context, _) {
        final pulse = _pulseAnim.value;
        final ripple = _rippleAnim.value;
        final rotation = _rotateController.value * 2 * math.pi;

        // Ripple opacity fades out as it expands
        final rippleOpacity = isRunning ? (1.0 - ripple) * 0.20 : 0.0;

        return SizedBox(
          width: 280.r,
          height: 280.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ripple ring (expands outward) ────────────────────────
              if (isRunning)
                Transform.scale(
                  scale: 0.88 + ripple * 0.18,
                  child: Container(
                    width: 280.r,
                    height: 280.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.primary
                            .withValues(alpha: rippleOpacity),
                        width: 3,
                      ),
                    ),
                  ),
                ),

              // ── Outer rotating dashed ring ───────────────────────────
              Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  size: Size(268.r, 268.r),
                  painter: _DashedRingPainter(
                    color: ColorsManager.primary
                        .withValues(alpha: isRunning ? 0.22 : 0.10),
                    dashCount: 36,
                    strokeWidth: 2,
                  ),
                ),
              ),

              // ── Middle static ring ────────────────────────────────────
              Transform.scale(
                scale: isRunning ? pulse : 1.0,
                child: Container(
                  width: 220.r,
                  height: 220.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.primary.withValues(
                        alpha: isRunning
                            ? 0.18 + (pulse - 0.96) * 2
                            : 0.10,
                      ),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // ── Inner glow circle ─────────────────────────────────────
              Container(
                width: 176.r,
                height: 176.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? ColorsManager.darkSurface
                      : ColorsManager.lightSurface,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primary.withValues(
                        alpha: isRunning
                            ? 0.12 + (pulse - 0.96) * 0.8
                            : 0.06,
                      ),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRunning ? 'Studying...' : 'Paused',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isRunning
                            ? ColorsManager.primary.withValues(alpha: 0.75)
                            : Colors.orange.withValues(alpha: 0.85),
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _timerService.formattedTime,
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: ColorsManager.primaryDark,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Arc progress on middle ring ────────────────────────────
              CustomPaint(
                size: Size(220.r, 220.r),
                painter: _ArcProgressPainter(
                  progress: _timerService.progressFraction,
                  color: ColorsManager.primaryDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Progress Section ───────────────────────────────────────────────────────
  Widget _buildProgressSection(bool isDark) {
    final progress = _timerService.progressFraction;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Elapsed: ${_timerService.formattedElapsed}',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.primaryDark,
              ),
            ),
            Text(
              _timerService.formattedGoal,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7.h,
            backgroundColor:
                ColorsManager.primary.withValues(alpha: 0.12),
            valueColor:
                const AlwaysStoppedAnimation(ColorsManager.primaryDark),
          ),
        ),
      ],
    );
  }

  // ── Controls ───────────────────────────────────────────────────────────────
  Widget _buildControls(bool isRunning, bool isDark) {
    return Row(
      children: [
        _ControlCircleButton(
          icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onTap: isRunning ? _timerService.pause : _timerService.resume,
          isDark: isDark,
          tooltip: isRunning ? 'Pause' : 'Resume',
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: _onFinish,
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    ColorsManager.primaryDark,
                    ColorsManager.primary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    color:
                        ColorsManager.primaryDark.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8.w),
                  Text(
                    'Finish Session',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        _ControlCircleButton(
          icon: Icons.free_breakfast_rounded,
          onTap: () {
            if (isRunning) {
              _timerService.pause();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('☕ Break started — timer paused.',
                      style: GoogleFonts.inter(fontSize: 13.sp)),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          isDark: isDark,
          tooltip: 'Take a break',
        ),
      ],
    );
  }

  // ── Daily Overview ─────────────────────────────────────────────────────────
  Widget _buildDailyOverview(ThemeData theme, bool isDark) {
    final sessionMins = _timerService.elapsedSeconds ~/ 60;
    final sessionHours = sessionMins / 60.0;
    final goalPct = (_timerService.progressFraction * 100).round();

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  size: 18.r, color: ColorsManager.primaryDark),
              SizedBox(width: 6.w),
              Text(
                'Session Overview',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Focus",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      sessionHours >= 1
                          ? '${sessionHours.toStringAsFixed(1)}h'
                          : '${sessionMins}m',
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Daily Goal',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$goalPct%',
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: ColorsManager.primaryDark,
                          ),
                        ),
                        TextSpan(
                          text: ' done',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quote Card ─────────────────────────────────────────────────────────────
  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorsManager.primaryDark, Color(0xff1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _quote['text']!,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _quote['author']!,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Goal Picker Bottom Sheet
// ══════════════════════════════════════════════════════════════════════════════
class _GoalPickerSheet extends StatefulWidget {
  final int currentGoalSeconds;
  final ValueChanged<int> onGoalSelected;

  const _GoalPickerSheet({
    required this.currentGoalSeconds,
    required this.onGoalSelected,
  });

  @override
  State<_GoalPickerSheet> createState() => _GoalPickerSheetState();
}

class _GoalPickerSheetState extends State<_GoalPickerSheet> {
  late int _selectedSeconds;
  // Slider range: 15 min – 4 h in minutes
  late double _sliderMinutes;

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.currentGoalSeconds;
    _sliderMinutes = (_selectedSeconds / 60).clamp(15.0, 240.0);
  }

  String _formatSeconds(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0 && m > 0) return '${h}h ${m}m';
    if (h > 0) return '${h}h';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorsManager.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),

          // Title row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.flag_rounded,
                    color: ColorsManager.primaryDark, size: 20.r),
              ),
              SizedBox(width: 12.w),
              Text(
                'Study Goal',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              // Current goal badge
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorsManager.primaryDark,
                      ColorsManager.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  _formatSeconds(_selectedSeconds),
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Preset chips
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _goalPresets.map((preset) {
              final selected = _selectedSeconds == preset.seconds;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSeconds = preset.seconds;
                    _sliderMinutes =
                        (preset.seconds / 60).clamp(15.0, 240.0);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [
                              ColorsManager.primaryDark,
                              ColorsManager.primary,
                            ],
                          )
                        : null,
                    color: selected
                        ? null
                        : theme.colorScheme.onSurface
                            .withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color: selected
                          ? Colors.transparent
                          : theme.colorScheme.onSurface
                              .withValues(alpha: 0.12),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    preset.label,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 28.h),

          // Custom slider
          Row(
            children: [
              Icon(Icons.tune_rounded,
                  size: 16.r,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              SizedBox(width: 8.w),
              Text(
                'Custom',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorsManager.primaryDark,
              inactiveTrackColor:
                  ColorsManager.primary.withValues(alpha: 0.15),
              thumbColor: Colors.white,
              overlayColor:
                  ColorsManager.primaryDark.withValues(alpha: 0.12),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 5,
              valueIndicatorColor: ColorsManager.primaryDark,
              valueIndicatorTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
            child: Slider(
              min: 15,
              max: 240,
              divisions: 45, // every 5 min
              value: _sliderMinutes,
              label: _formatSeconds(_sliderMinutes.round() * 60),
              onChanged: (val) {
                setState(() {
                  _sliderMinutes = val;
                  _selectedSeconds = (val.round() * 60);
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15m',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4))),
              Text('4h',
                  style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4))),
            ],
          ),

          SizedBox(height: 28.h),

          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r)),
              ),
              onPressed: () {
                widget.onGoalSelected(_selectedSeconds);
                Navigator.pop(context);
              },
              child: Text(
                'Set Goal — ${_formatSeconds(_selectedSeconds)}',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Reusable widgets & painters
// ══════════════════════════════════════════════════════════════════════════════
class _ControlCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final String tooltip;

  const _ControlCircleButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.r),
        child: Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? ColorsManager.darkSurfaceVariant
                : ColorsManager.lightSurfaceVariant,
            border: Border.all(
              color: ColorsManager.primary.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 22.r, color: ColorsManager.primaryDark),
        ),
      ),
    );
  }
}

// Rotating dashed ring
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;
  final double strokeWidth;

  const _DashedRingPainter({
    required this.color,
    required this.dashCount,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;
    final step = 2 * math.pi / dashCount;
    final dashAngle = step * 0.45;

    for (int i = 0; i < dashCount; i++) {
      final start = i * step;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color || old.dashCount != dashCount;
}

// Arc progress on middle ring
class _ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _ArcProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcProgressPainter old) =>
      old.progress != progress || old.color != color;
}
