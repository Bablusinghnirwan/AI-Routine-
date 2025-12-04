import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';

// Custom ClayCard to match React design exactly
class ClayCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = EdgeInsets.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24), // rounded-3xl
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class ProgressReportScreen extends StatelessWidget {
  const ProgressReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Text(
                    'My Progress 📊',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gray700,
                    ),
                  ),
                  _buildCircleButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Filter Pill
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gray100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.green500,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Last 7 Days',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Big Chart Card
                  ClayCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Weekly Activity',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.green50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.show_chart_rounded,
                                color: AppColors.green500,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Custom Bar Chart
                        SizedBox(
                          height: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildBar('M', 45),
                              _buildBar('T', 70),
                              _buildBar('W', 30),
                              _buildBar('T', 85),
                              _buildBar('F', 50),
                              _buildBar('S', 95),
                              _buildBar('S', 60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildStatCard(
                        title: 'Total Tasks',
                        value: '42',
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.purple50,
                        accentColor: AppColors.purple500,
                        textColor: AppColors.purple400,
                        valueColor:
                            AppColors.purple700, // purple-800 equivalent
                      ),
                      _buildStatCard(
                        title: 'Efficiency',
                        value: '87%',
                        icon: Icons.bolt_rounded,
                        color: AppColors.orange100.withOpacity(
                          0.5,
                        ), // orange-50
                        accentColor: AppColors.orange500,
                        textColor: AppColors.orange400,
                        valueColor: const Color(0xFF9A3412), // orange-800
                      ),
                      _buildStatCard(
                        title: 'Focused',
                        value: '12h',
                        icon: Icons.access_time_rounded,
                        color: AppColors.blue50,
                        accentColor: AppColors.blue500,
                        textColor: AppColors.blue400,
                        valueColor: AppColors.blue800,
                      ),
                      _buildStatCard(
                        title: 'Streak',
                        value: '5 Days',
                        icon: Icons.star_rounded,
                        color: AppColors.pink100.withOpacity(0.5), // pink-50
                        accentColor: AppColors.pink600, // pink-500
                        textColor: AppColors.pink400,
                        valueColor: const Color(0xFF9D174D), // pink-800
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.gray500, size: 20),
      ),
    );
  }

  Widget _buildBar(String label, double heightPercent) {
    final isHigh = heightPercent > 80;
    final isWeekend = label == 'S';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24, // Reduced width to prevent overflow
          height: (140 * heightPercent) / 100, // Reduced max height base
          decoration: BoxDecoration(
            color: isHigh ? AppColors.green400 : AppColors.green100,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: isHigh
                ? [
                    BoxShadow(
                      color: AppColors.green400.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isWeekend ? Colors.red[300] : AppColors.gray400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color accentColor,
    required Color textColor,
    required Color valueColor,
  }) {
    return ClayCard(
      color: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
