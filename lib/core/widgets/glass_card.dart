import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_routine/core/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  final bool hasGlow;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGlass,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: hasGlow
                      ? AppColors.glowAccent.withOpacity(0.5)
                      : Colors.white.withOpacity(0.2),
                  width: hasGlow ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: hasGlow
                        ? AppColors.glowAccent.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: hasGlow ? 30 : 25,
                    spreadRadius: hasGlow ? 2 : -5,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
