import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_flow/Core/Routes_Manager/routes.dart';
import 'package:study_flow/Core/Services/user_prefs_service.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class SetupScreenBody extends StatefulWidget {
  const SetupScreenBody({super.key});

  @override
  State<SetupScreenBody> createState() => _SetupScreenBodyState();
}

class _SetupScreenBodyState extends State<SetupScreenBody>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  int? _selectedAge;
  String? _selectedGrade;
  bool _isLoading = false;

  late final AnimationController _entranceController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _grades = [
    ('🎒', 'High School'),
    ('📖', 'Undergraduate'),
    ('🎓', 'Postgraduate'),
    ('💼', 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // 5 staggered elements: header, name, age, grade, button
    _fadeAnims = List.generate(5, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnims = List.generate(5, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entranceController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAge == null) {
      _showSnack('Please select your age');
      return;
    }
    if (_selectedGrade == null) {
      _showSnack('Please select your grade level');
      return;
    }

    setState(() => _isLoading = true);
    await UserPrefsService.saveUserProfile(
      name: _nameController.text.trim(),
      age: _selectedAge!,
      grade: _selectedGrade!,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, Routes.main_layout);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        backgroundColor: ColorsManager.primaryDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xff1A1C23), const Color(0xff23262F)]
                : [ColorsManager.primaryDark, ColorsManager.primary],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Header ────────────────────────────────────────────
                _animated(
                  0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👋', style: TextStyle(fontSize: 44.sp)),
                      SizedBox(height: 8.h),
                      Text(
                        "Let's set up\nyour profile",
                        style: GoogleFonts.inter(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tell us a bit about yourself so we can\npersonalise your study experience.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // ── Name Field ────────────────────────────────────────
                _animated(
                  1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Your Name'),
                      SizedBox(height: 10.h),
                      _buildNameField(),
                    ],
                  ),
                ),

                SizedBox(height: 28.h),

                // ── Age Picker ────────────────────────────────────────
                _animated(
                  2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Your Age'),
                      SizedBox(height: 12.h),
                      _buildAgeChips(),
                    ],
                  ),
                ),

                SizedBox(height: 28.h),

                // ── Grade Selector ────────────────────────────────────
                _animated(
                  3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Grade Level'),
                      SizedBox(height: 12.h),
                      _buildGradeGrid(),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                // ── Submit Button ─────────────────────────────────────
                _animated(4, child: _buildSubmitButton()),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────

  Widget _animated(int index, {required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.6),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      textCapitalization: TextCapitalization.words,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'e.g. Ahmed Hassan',
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withValues(alpha: 0.35),
          fontSize: 15.sp,
        ),
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: Colors.white.withValues(alpha: 0.6),
          size: 22.r,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorStyle: GoogleFonts.inter(
          color: const Color(0xFFFFCDD2),
          fontSize: 12.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
    );
  }

  Widget _buildAgeChips() {
    final ages = List.generate(15, (i) => i + 13); // 13–27

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ...ages.map((age) => _ageChip(age, '$age')),
        _ageChip(28, '28+'),
      ],
    );
  }

  Widget _ageChip(int age, String label) {
    final isSelected = _selectedAge == age;
    return GestureDetector(
      onTap: () => setState(() => _selectedAge = age),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: isSelected ? ColorsManager.primaryDark : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGradeGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 2.4,
      children: _grades
          .map((g) => _gradeCard(emoji: g.$1, label: g.$2))
          .toList(),
    );
  }

  Widget _gradeCard({required String emoji, required String label}) {
    final isSelected = _selectedGrade == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGrade = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? ColorsManager.primaryDark : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(
                      ColorsManager.primaryDark,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Let's Go!",
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: ColorsManager.primaryDark,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: ColorsManager.primaryDark,
                      size: 22.r,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
