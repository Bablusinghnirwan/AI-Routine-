import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/calendar/widgets/sticky_calendar_tile.dart';
import 'package:my_routine/features/tasks/controllers/task_controller.dart';
import 'package:my_routine/features/calendar/widgets/add_event_sheet.dart';
import 'package:my_routine/features/tasks/models/task_model.dart';

enum CalendarView { month, day }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarView _viewMode = CalendarView.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'Smart Calendar 🗓️',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _viewMode == CalendarView.month
                  ? Icons.view_day_rounded
                  : Icons.calendar_view_month_rounded,
              color: AppColors.gray700,
            ),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == CalendarView.month
                    ? CalendarView.day
                    : CalendarView.month;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddEventSheet(selectedDate: _selectedDay),
          );
        },
        backgroundColor: AppColors.green500,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          return Column(
            children: [
              // AI Auto-Schedule Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: ClayButton(
                  icon: Icons.auto_awesome_rounded,
                  label: "AI Auto-Schedule",
                  onTap: () => _autoScheduleFocusBlock(taskController),
                  isActive: true,
                  activeColor: AppColors.purple100,
                  iconColor: AppColors.purple600,
                  width: double.infinity,
                  height: 50,
                ),
              ),

              Expanded(
                child: _viewMode == CalendarView.month
                    ? _buildMonthlyView(taskController)
                    : _buildDailyTimelineView(taskController),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMonthlyView(TaskController taskController) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedDay.year,
      _focusedDay.month,
    );
    final firstDayOffset = DateUtils.firstDayOffset(
      _focusedDay.year,
      _focusedDay.month,
      MaterialLocalizations.of(context),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Header (Month Navigation)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_focusedDay),
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
            Row(
              children: [
                _buildNavButton(Icons.chevron_left, () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                    );
                  });
                }),
                const SizedBox(width: 12),
                _buildNavButton(Icons.chevron_right, () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                    );
                  });
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Calendar Grid
        ClayCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Days Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: days
                    .map(
                      (d) => Text(
                        d,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray400,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Dates Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.0,
                ),
                itemCount: daysInMonth + firstDayOffset,
                itemBuilder: (context, index) {
                  if (index < firstDayOffset) return const SizedBox();

                  final day = index - firstDayOffset + 1;
                  final date = DateTime(
                    _focusedDay.year,
                    _focusedDay.month,
                    day,
                  );
                  final isSelected = isSameDay(date, _selectedDay);
                  final isToday = isSameDay(date, DateTime.now());

                  // Filter tasks for this day
                  final dayTasks = taskController.tasks
                      .where((t) => isSameDay(t.dateTime, date))
                      .toList();

                  // Calculate Progress Color
                  Color? progressColor;
                  if (dayTasks.isNotEmpty && date.isBefore(DateTime.now())) {
                    final completed = dayTasks
                        .where((t) => t.isCompleted)
                        .length;
                    final total = dayTasks.length;
                    final ratio = completed / total;

                    if (ratio == 1.0) {
                      progressColor = AppColors.green300; // Perfect
                    } else if (ratio >= 0.5) {
                      progressColor = AppColors.yellow200; // Average
                    } else {
                      progressColor = AppColors.pink100; // Missed
                    }
                  }

                  // Determine Sticker
                  String? sticker;
                  if (dayTasks.isNotEmpty) {
                    // Simple keyword matching for demo
                    final titles = dayTasks
                        .map((t) => (t.title ?? '').toLowerCase())
                        .join(' ');
                    if (titles.contains('gym') || titles.contains('workout')) {
                      sticker = '🏋️';
                    } else if (titles.contains('birthday') ||
                        titles.contains('party')) {
                      sticker = '🎂';
                    } else if (titles.contains('yoga') ||
                        titles.contains('meditate')) {
                      sticker = '🧘';
                    } else if (titles.contains('work') ||
                        titles.contains('meeting')) {
                      sticker = '💼';
                    } else if (titles.contains('date') ||
                        titles.contains('dinner')) {
                      sticker = '🍷';
                    }
                  }

                  return StickyCalendarTile(
                    date: date,
                    isSelected: isSelected,
                    isToday: isToday,
                    isOutsideMonth: false,
                    events: const [], // Using stickers instead
                    progressColor: progressColor,
                    sticker: sticker,
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                        // Optional: Switch to day view on tap
                        // _viewMode = CalendarView.day;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Selected Day Agenda Preview
        _buildAgendaList(taskController),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildDailyTimelineView(TaskController taskController) {
    final dayTasks =
        taskController.tasks
            .where((t) => isSameDay(t.dateTime, _selectedDay))
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Column(
      children: [
        // Day Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.subtract(
                      const Duration(days: 1),
                    );
                    _focusedDay = _selectedDay;
                  });
                },
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE').format(_selectedDay),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: AppColors.gray500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d').format(_selectedDay),
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      color: AppColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.add(const Duration(days: 1));
                    _focusedDay = _selectedDay;
                  });
                },
              ),
            ],
          ),
        ),

        // Timeline
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 24, // 24 Hours
            itemBuilder: (context, index) {
              final hour = index;
              final hourTasks = dayTasks
                  .where((t) => t.dateTime.hour == hour)
                  .toList();

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Column
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppColors.gray400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Events Column
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppColors.gray300.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hourTasks.isEmpty)
                            const SizedBox(height: 20) // Empty slot space
                          else
                            ...hourTasks.map(
                              (task) =>
                                  _buildTimelineTask(task, taskController),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTask(Task task, TaskController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.green100 : AppColors.blue100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted ? AppColors.green300 : AppColors.blue400,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.title ?? 'Untitled',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.gray800,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          if (task.isCompleted)
            const Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: AppColors.green600,
            ),
        ],
      ),
    );
  }

  Widget _buildAgendaList(TaskController taskController) {
    final tasks = taskController.tasks
        .where((t) => isSameDay(t.dateTime, _selectedDay))
        .toList();

    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "No tasks for this day.\nTap + to add one!",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(color: AppColors.gray400),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agenda',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 12),
        ...tasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ClayCard(
              color: task.isCompleted ? AppColors.green50 : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => taskController.toggleTaskCompletion(task),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? AppColors.green100
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        task.isCompleted
                            ? Icons.check_rounded
                            : Icons.circle_outlined,
                        color: task.isCompleted
                            ? AppColors.green600
                            : AppColors.gray400,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title ?? 'Untitled',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: task.isCompleted
                                ? AppColors.gray500
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
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.gray400),
      ),
    );
  }

  void _autoScheduleFocusBlock(TaskController controller) {
    // Simulate AI finding a slot
    final now = DateTime.now();
    final todayTasks = controller.tasks
        .where((t) => isSameDay(t.dateTime, now))
        .toList();

    // Simple logic: Find a slot at 10 AM, 2 PM, or 4 PM that is free
    DateTime? slot;
    for (int hour in [10, 14, 16]) {
      final potentialTime = DateTime(now.year, now.month, now.day, hour);
      if (!todayTasks.any((t) => t.dateTime.hour == hour)) {
        slot = potentialTime;
        break;
      }
    }

    if (slot != null) {
      controller.addTask("Focus Block 🧠", slot);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "AI scheduled a Focus Block at ${DateFormat('h:mm a').format(slot)}! ✨",
          ),
          backgroundColor: AppColors.purple500,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No free slots found for auto-scheduling today!"),
          backgroundColor: AppColors.orange400,
        ),
      );
    }
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
