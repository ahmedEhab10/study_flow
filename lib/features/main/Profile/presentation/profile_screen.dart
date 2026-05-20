import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:study_flow/Core/Provider/Theme_provider.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

// ─── Profile Screen ───────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = 75.0 + MediaQuery.paddingOf(context).bottom + 24.h;
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Profile',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  // ── Avatar + Name Card ────────────────────────────────────
                  _ProfileHeaderCard(),
                  SizedBox(height: 28.h),
                  // ── Section: Appearance ───────────────────────────────────
                  _SectionLabel(label: 'Appearance'),
                  SizedBox(height: 10.h),
                  _AppearanceCard(),
                  SizedBox(height: 28.h),
                  // ── Section: About ────────────────────────────────────────
                  _SectionLabel(label: 'About'),
                  SizedBox(height: 10.h),
                  _AboutCard(),
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Header Card ──────────────────────────────────────────────────────
class _ProfileHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              theme.dividerTheme.color ??
              ColorsManager.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [ColorsManager.primary, ColorsManager.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'A',
                style: GoogleFonts.inter(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Name & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmed',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Student · StudyFlow AI',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          // Edit placeholder
          Icon(
            Icons.edit_outlined,
            size: 20.r,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

// ─── Appearance Card (with ThemeToggle) ──────────────────────────────────────
class _AppearanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              theme.dividerTheme.color ??
              ColorsManager.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Theme toggle row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: ColorsManager.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.palette_outlined,
                    size: 18.r,
                    color: ColorsManager.primary,
                  ),
                ),
                SizedBox(width: 14.w),
                // Label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark Mode',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Switch between light and dark theme',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated pill switch
                const ThemeToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── About Card ───────────────────────────────────────────────────────────────
class _AboutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              theme.dividerTheme.color ??
              ColorsManager.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _AboutTile(
            icon: Icons.info_outline_rounded,
            label: 'App Version',
            trailing: '1.0.0',
            showDivider: true,
          ),
          _AboutTile(
            icon: Icons.shield_outlined,
            label: 'Privacy Policy',
            trailing: null,
            showDivider: true,
          ),
          _AboutTile(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            trailing: null,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final bool showDivider;
  const _AboutTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.showDivider,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.r, color: ColorsManager.primary),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              trailing != null
                  ? Text(
                      trailing!,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.chevron_right_rounded,
                      size: 20.r,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.35,
                      ),
                    ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 66.w,
            color:
                theme.dividerTheme.color ??
                ColorsManager.primary.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
      ),
    );
  }
}

// ─── ThemeToggle widget ───────────────────────────────────────────────────────
/// Drop this widget anywhere — Profile screen, AppBar actions, Settings page.
///
/// Usage:
///   const ThemeToggle()              // pill switch (default)
///   ThemeToggle(showLabel: true)     // labeled row with switch
class ThemeToggle extends StatelessWidget {
  final bool showLabel;
  const ThemeToggle({super.key, this.showLabel = false});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final isDark = provider.isDark;
    if (showLabel) {
      return _LabeledToggle(isDark: isDark, onTap: provider.toggleTheme);
    }
    return _PillSwitch(value: isDark, onChanged: (_) => provider.toggleTheme());
  }
}

// ─── Compact pill switch ──────────────────────────────────────────────────────
class _PillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PillSwitch({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? ColorsManager.primary
              : ColorsManager.primary.withValues(alpha: 0.2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      value
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      key: ValueKey(value),
                      size: 12,
                      color: value
                          ? ColorsManager.primary
                          : Colors.amber.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Labeled row toggle (for future settings-style usage) ─────────────────────
class _LabeledToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _LabeledToggle({required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorsManager.primary.withValues(alpha: isDark ? 0.2 : 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                key: ValueKey(isDark),
                color: isDark ? Colors.amber : ColorsManager.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isDark ? 'Dark mode' : 'Light mode',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            _PillSwitch(value: isDark, onChanged: (_) => onTap()),
          ],
        ),
      ),
    );
  }
}
