import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_routine/core/theme.dart';

// --- Micro-Animation: Bouncing Button ---
class BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double scaleFactor;

  const BouncingButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleFactor = 0.95,
  });

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

// --- Sticker Icon (Cute Doodles) ---
class StickerIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final bool isGlowing;

  const StickerIcon({
    super.key,
    required this.icon,
    this.color = AppColors.pastelYellow,
    this.size = 24,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isGlowing
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            )
          : null,
      child: Transform.rotate(
        angle: 0.1, // Slight playful tilt
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool hasGlow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassColor =
        color ?? (isDark ? AppColors.cardGlass : Colors.white.withOpacity(0.7));
    final borderColor = isDark
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.4);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [hasGlow ? AppTheme.glowShadow : AppTheme.softShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppTheme.kPadding),
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
              border: Border.all(
                color: hasGlow
                    ? AppColors.glowAccent.withOpacity(0.5)
                    : borderColor,
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class StickyNoteCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;

  const StickyNoteCard({
    super.key,
    required this.child,
    this.color = AppColors.pastelYellow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onPressed: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6), // 12px gap total
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.kCardRadius),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.kPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CuteButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;

  const CuteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onPressed: onPressed,
      child: Container(
        height: AppTheme.kButtonHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: color ?? AppColors.glowAccent,
          borderRadius: BorderRadius.circular(26), // Fully rounded
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.glowAccent).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class UniversalBackButton extends StatelessWidget {
  const UniversalBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onPressed: () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 22,
        ),
      ),
    );
  }
}

class ChallbotMascot extends StatelessWidget {
  final double size;
  final bool isHappy;

  const ChallbotMascot({super.key, this.size = 100, this.isHappy = false});

  @override
  Widget build(BuildContext context) {
    // Placeholder for actual mascot image
    // In a real app, use Image.asset('assets/images/mascot.png')
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [AppTheme.glowShadow],
      ),
      child: Center(
        child: Text(
          isHappy ? '^_^' : '0_0',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
