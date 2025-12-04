import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/tasks/controllers/task_controller.dart';
import 'package:my_routine/features/auth/auth_controller.dart';
import 'package:my_routine/features/tasks/views/add_task_screen.dart';
import 'package:my_routine/features/notes/note_controller.dart';
import 'package:my_routine/features/notes/note_model.dart';
import 'package:my_routine/features/habits/habit_tracker_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<TaskController>(context, listen: false).loadTasks();
        Provider.of<NoteController>(context, listen: false).loadNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final noteController = Provider.of<NoteController>(context);
    final authController = Provider.of<AuthController>(context);
    final user = authController.currentUser;

    // Filter tasks for today
    final today = DateTime.now();
    final tasks = taskController.tasks
        .where(
          (t) =>
              t.dateTime.year == today.year &&
              t.dateTime.month == today.month &&
              t.dateTime.day == today.day,
        )
        .toList();

    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final totalTasks = tasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    // Filter notes for today
    final notes = noteController.getNotesForDate(today);

    return Scaffold(
      backgroundColor: AppColors.green100, // Fix: Explicit light background
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ), // Remove horizontal padding
          children: [
            // Greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.userMetadata?['full_name']?.split(' ')[0] ?? 'Achiever'}! 👋',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to crush your goals today?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Progress Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildProgressCard(progress),
            ),
            const SizedBox(height: 24),

            // Quick Goals/Tasks Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Today\'s Plan',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.gray700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ClayButton(
                    icon: Icons.add_rounded,
                    label: "Add Task",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskScreen(),
                        ),
                      );
                    },
                    isActive: true,
                    activeColor: AppColors.green100,
                    iconColor: AppColors.green700,
                    height: 40,
                    width: 110,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            if (tasks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "No tasks for today yet!",
                    style: GoogleFonts.nunito(color: AppColors.gray400),
                  ),
                ),
              )
            else
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildTaskItem(task, taskController),
                ),
              ),

            const SizedBox(height: 24),

            // Habit Tracker (Full Width)
            const HabitTrackerWidget(),
            const SizedBox(height: 24),

            // Sticky Notes Header
            if (notes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Sticky Notes',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Sticky Notes Grid (Horizontal - Full Width)
              SizedBox(
                height: 180,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ), // Content padding
                  scrollDirection: Axis.horizontal,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return _buildStickyNoteItem(notes[index]);
                  },
                ),
              ),
            ],

            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress) {
    return ClayCard(
      color: AppColors.blue100,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Daily Progress',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.fredoka(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue900,
                      ),
                    ),
                    Text(
                      'Almost done!',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue800.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    const Text('🔥', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(dynamic task, TaskController controller) {
    return GestureDetector(
      onTap: () => controller.toggleTaskCompletion(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.green400 : AppColors.gray50,
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted
                      ? AppColors.green400
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted
                          ? AppColors.gray400
                          : AppColors.gray700,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    DateFormat('h:mm a').format(task.dateTime),
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getCategoryColor('work'), // Default for now
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyNoteItem(Note note) {
    return Transform.rotate(
      angle: note.rotation,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(note.color.replaceAll('#', '0xFF'))),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tape visual
            Center(
              child: Container(
                width: 40,
                height: 12,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Text(
                note.content,
                style: GoogleFonts.patrickHand(
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return AppColors.blue400;
      case 'personal':
        return AppColors.purple400;
      case 'shop':
        return AppColors.pink400;
      default:
        return AppColors.green400;
    }
  }
}
