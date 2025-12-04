import 'package:flutter/material.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/widgets/glass_card.dart';

class QuickStatsRow extends StatelessWidget {
  final int completed;
  final int pending;
  final double progress;

  const QuickStatsRow({
    super.key,
    required this.completed,
    required this.pending,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatPill(
            context,
            icon: Icons.check_circle_outline,
            label: 'Done',
            value: '$completed',
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatPill(
            context,
            icon: Icons.hourglass_empty,
            label: 'Pending',
            value: '$pending',
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatPill(
            context,
            icon: Icons.pie_chart_outline,
            label: 'Today',
            value: '${(progress * 100).toInt()}%',
            color: AppColors.glowAccent,
            hasGlow: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool hasGlow = false,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      hasGlow: hasGlow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
