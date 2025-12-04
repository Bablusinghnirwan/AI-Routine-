import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_routine/core/widgets/glass_card.dart';
import 'package:my_routine/features/summary/summary_controller.dart';

class WeeklyTrendWidget extends StatelessWidget {
  const WeeklyTrendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SummaryController>(
      builder: (context, controller, child) {
        final avgScore = controller.getWeeklyAverageScore();

        Color glowColor;
        if (avgScore > 70) {
          glowColor = const Color(0xFF4ADE80); // Green
        } else if (avgScore >= 40) {
          glowColor = const Color(0xFFEAB308); // Yellow
        } else {
          glowColor = const Color(0xFFF87171); // Red
        }

        return GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Weekly Progress",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${avgScore.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Simple trend visualization (bar)
                    Expanded(
                      child: Container(
                        height: 8,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (avgScore / 100).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: glowColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
