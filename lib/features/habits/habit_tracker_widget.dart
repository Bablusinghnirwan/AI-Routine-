import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';

class HabitTrackerWidget extends StatefulWidget {
  const HabitTrackerWidget({super.key});

  @override
  State<HabitTrackerWidget> createState() => _HabitTrackerWidgetState();
}

class _HabitTrackerWidgetState extends State<HabitTrackerWidget> {
  // Mock data for habits
  final List<Map<String, dynamic>> _habits = [
    {'name': 'Drink Water', 'streak': 5, 'isDone': false},
    {'name': 'Read Book', 'streak': 12, 'isDone': true},
    {'name': 'Meditate', 'streak': 3, 'isDone': false},
  ];

  void _toggleHabit(int index) {
    setState(() {
      _habits[index]['isDone'] = !_habits[index]['isDone'];
      if (_habits[index]['isDone']) {
        _habits[index]['streak']++;
      } else {
        _habits[index]['streak']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Habit Tracker 🔥',
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.gray800,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _habits.length,
            itemBuilder: (context, index) {
              final habit = _habits[index];
              return _buildHabitCard(habit, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit, int index) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ClayCard(
        color: habit['isDone'] ? AppColors.green100 : Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              habit['name'],
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 16,
                  color: AppColors.orange500,
                ),
                const SizedBox(width: 4),
                Text(
                  '${habit['streak']}',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orange500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _toggleHabit(index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: habit['isDone'] ? AppColors.green500 : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit['isDone']
                        ? AppColors.green500
                        : AppColors.gray300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: habit['isDone']
                    ? const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
