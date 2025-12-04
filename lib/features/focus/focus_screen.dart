import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _initialTime = 25 * 60; // 25 minutes in seconds
  int _remainingTime = _initialTime;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) return;
    setState(() {
      _isRunning = true;
      _isCompleted = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _timer = null;
          _isRunning = false;
          _isCompleted = true;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _remainingTime = _initialTime;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildPlantIcon() {
    IconData icon;
    Color color;
    double size;

    if (_isCompleted) {
      icon = Icons.park_rounded; // Full Tree
      color = AppColors.green600;
      size = 120;
    } else if (_remainingTime > _initialTime * 0.8) {
      icon = Icons.grain_rounded; // Seed
      color = AppColors.orange400;
      size = 60;
    } else if (_remainingTime > _initialTime * 0.2) {
      icon = Icons.spa_rounded; // Sprout
      color = AppColors.green400;
      size = 90;
    } else {
      icon = Icons.park_rounded; // Growing Tree
      color = AppColors.green500;
      size = 100;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: size, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'Focus Timer ⏱️',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPlantIcon(),
            const SizedBox(height: 40),
            Text(
              _isCompleted ? 'Focus Complete!' : _formatTime(_remainingTime),
              style: GoogleFonts.fredoka(
                fontSize: _isCompleted ? 32 : 64,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            if (_isCompleted) ...[
              const SizedBox(height: 8),
              Text(
                'Great job! Take a break. 🌿',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: AppColors.gray600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning && !_isCompleted)
                  ClayButton(
                    icon: Icons.play_arrow_rounded,
                    onTap: _startTimer,
                    isActive: false,
                    height: 80,
                    width: 80,
                    iconColor: AppColors.green600,
                  ),
                if (_isRunning)
                  ClayButton(
                    icon: Icons.pause_rounded,
                    onTap: _pauseTimer,
                    isActive: false,
                    height: 80,
                    width: 80,
                    iconColor: AppColors.orange500,
                  ),
                const SizedBox(width: 24),
                ClayButton(
                  icon: Icons.refresh_rounded,
                  onTap: _resetTimer,
                  isActive: false,
                  height: 60,
                  width: 60,
                  iconColor: AppColors.gray600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
