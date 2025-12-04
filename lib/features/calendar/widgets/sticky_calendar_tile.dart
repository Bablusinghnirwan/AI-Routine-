import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';

class StickyCalendarTile extends StatefulWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isOutsideMonth;
  final List<Map<String, dynamic>> events;
  final VoidCallback onTap;
  final Color? progressColor; // New: For progress coding
  final String? sticker; // New: For emoji stickers

  const StickyCalendarTile({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isOutsideMonth,
    required this.events,
    required this.onTap,
    this.progressColor,
    this.sticker,
  });

  @override
  State<StickyCalendarTile> createState() => _StickyCalendarTileState();
}

class _StickyCalendarTileState extends State<StickyCalendarTile>
    with SingleTickerProviderStateMixin {
  late double _rotationAngle;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Generate a random rotation between -6 and +6 degrees
    final random = Random(widget.date.hashCode);
    final angleDeg = -6 + random.nextDouble() * 12;
    _rotationAngle = angleDeg * (pi / 180);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: _rotationAngle,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(StickyCalendarTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base color: Use progressColor if available, otherwise default glass
    final baseColor =
        widget.progressColor?.withOpacity(0.8) ??
        (isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.6));

    final selectedColor = isDark
        ? AppColors.primaryMedium.withOpacity(0.8)
        : Colors.white;

    final borderColor = widget.isSelected
        ? AppColors.glowAccent
        : Colors.white.withOpacity(0.3);

    final shadowColor = widget.isSelected
        ? AppColors.glowAccent.withOpacity(0.4)
        : Colors.black.withOpacity(0.1);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: widget.isSelected ? 8 : 3,
                      offset: widget.isSelected
                          ? const Offset(0, 4)
                          : const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isSelected ? selectedColor : baseColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderColor,
                          width: widget.isSelected ? 1.5 : 0.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Day Number
                          Center(
                            child: Text(
                              '${widget.date.day}',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: widget.isOutsideMonth
                                    ? AppColors.textSecondary.withOpacity(0.5)
                                    : (widget.isSelected && isDark
                                          ? Colors.white
                                          : AppColors.textDark),
                              ),
                            ),
                          ),

                          // Today Indicator
                          if (widget.isToday && !widget.isSelected)
                            Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppColors.glowAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),

                          // Sticker (Emoji)
                          if (widget.sticker != null)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Text(
                                widget.sticker!,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),

                          // Sparkle for selected
                          if (widget.isSelected)
                            const Positioned(
                              top: 2,
                              left: 2,
                              child: Icon(
                                Icons.auto_awesome,
                                size: 8,
                                color: AppColors.pastelYellow,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
