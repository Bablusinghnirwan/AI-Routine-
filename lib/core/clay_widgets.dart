import 'package:flutter/material.dart';
import 'package:my_routine/core/theme.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isInteractive;

  const ClayCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(22), child: child),
      ),
    );
  }
}

class ClayButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color iconColor;

  const ClayButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.label,
    this.isActive = false,
    this.activeColor =
        Colors.transparent, // Default to transparent as per React
    this.inactiveColor = Colors.transparent,
    this.iconColor = AppColors.gray400,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.green200
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 2), // Inner shadow simulation
                          blurRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                widget.icon,
                size: 24,
                color: widget.isActive ? AppColors.green700 : widget.iconColor,
              ),
            ),
            if (widget.label != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.label!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray400.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
