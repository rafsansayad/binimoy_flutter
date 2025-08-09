import 'package:flutter/material.dart';
import 'app_buttons.dart';

class DockAction {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  const DockAction({required this.icon, this.tooltip, this.onPressed});
}

class AppBottomDock extends StatelessWidget {
  final VoidCallback? onScan;
  final VoidCallback? onPrimaryTap;
  final String primaryLabel;
  final List<DockAction> trailingActions;
  final double spacing;
  final bool showDivider;
  final double controlHeight;
  final int activeIndex;

  const AppBottomDock({
    super.key,
    required this.onScan,
    required this.onPrimaryTap,
    this.primaryLabel = 'Pay or request',
    this.trailingActions = const [],
    this.spacing = 4,
    this.showDivider = false,
    this.controlHeight = 38,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.045), blurRadius: 8, offset: const Offset(0, -2)),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: Scan + Primary CTA
          Row(
            children: [
              SizedBox(
                height: controlHeight,
                child: OutlinedButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                  label: const Text('Scan'),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size(0, controlHeight),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: PrimaryPillButton(
                  label: primaryLabel,
                  onPressed: onPrimaryTap,
                  icon: Icons.payments_rounded,
                  expand: true,
                  height: controlHeight,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          if (showDivider)
            Divider(height: spacing, color: colorScheme.outlineVariant.withOpacity(0.5)),
          // Bottom row: evenly spaced small icon actions + active dot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(trailingActions.length, (index) {
              final DockAction a = trailingActions[index];
              final bool isActive = index == activeIndex;
              final Color iconColor = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconActionButton(icon: a.icon, onPressed: a.onPressed, tooltip: a.tooltip, color: iconColor, iconSize: 18),
                  const SizedBox(height: 2),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isActive ? colorScheme.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

