import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_flow/Core/Provider/Theme_provider.dart';
import 'package:study_flow/Core/resources/Colors_Manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Screen')));
  }
}

/// Drop this widget anywhere — AppBar actions, settings page, drawer header, etc.
///
/// Usage:
///   actions: [ThemeToggle()],               // in AppBar
///   child: ThemeToggle(showLabel: true),     // in settings row
class ThemeToggle extends StatelessWidget {
  /// Show a text label next to the toggle (e.g. "Dark mode")
  final bool showLabel;

  const ThemeToggle({super.key, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final isDark = provider.isDark;

    if (showLabel) {
      return _LabeledToggle(isDark: isDark, onTap: provider.toggleTheme);
    }
    return _IconToggle(isDark: isDark, onTap: provider.toggleTheme);
  }
}

// ─── Compact icon button (for AppBar) ─────────────────────────────────────

class _IconToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _IconToggle({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => RotationTransition(
        turns: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: IconButton(
        key: ValueKey(isDark),
        icon: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: isDark ? Colors.amber : ColorsManager.primary,
        ),
        tooltip: isDark ? 'Switch to Light mode' : 'Switch to Dark mode',
        onPressed: onTap,
      ),
    );
  }
}

// ─── Labeled row toggle (for Settings page) ───────────────────────────────

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
            color: ColorsManager.primary.withOpacity(isDark ? 0.2 : 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
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
            // Label
            Text(
              isDark ? 'Dark mode' : 'Light mode',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            // Animated Switch
            _AnimatedSwitch(value: isDark, onChanged: (_) => onTap()),
          ],
        ),
      ),
    );
  }
}

// ─── Custom animated pill switch ──────────────────────────────────────────

class _AnimatedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AnimatedSwitch({required this.value, required this.onChanged});

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
              : ColorsManager.primary.withOpacity(0.2),
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
