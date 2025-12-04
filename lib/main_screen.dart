import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/tasks/views/home_screen.dart';
import 'package:my_routine/features/calendar/calendar_screen.dart';
import 'package:my_routine/features/diary/diary_list_screen.dart';
import 'package:my_routine/features/ai/ai_screen.dart';
import 'package:my_routine/features/profile/profile_screen.dart';
import 'package:my_routine/features/progress/progress_report_screen.dart';
import 'package:my_routine/features/notes/sticky_notes_screen.dart';
import 'package:my_routine/features/notifications/notification_controller.dart';
import 'package:my_routine/features/notifications/notification_screen.dart';
import 'package:my_routine/features/focus/focus_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool _isSidebarOpen = false;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _navigateToSecondaryScreen(Widget screen) {
    _toggleSidebar(); // Close sidebar first
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      body: Stack(
        children: [
          // Sidebar (Drawer)
          _buildSidebar(context),

          // Main Content Frame
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_sidebarAnimation.value * 220, 0),
                child: Transform.scale(
                  scale: 1.0 - (_sidebarAnimation.value * 0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.green100,
                      borderRadius: BorderRadius.circular(
                        _sidebarAnimation.value * 30,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(-10, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        _sidebarAnimation.value * 30,
                      ),
                      child: Column(
                        children: [
                          _buildHeader(),
                          Expanded(
                            child: Navigator(
                              key: _navigatorKey,
                              onGenerateRoute: (settings) {
                                return MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                );
                              },
                            ),
                          ),
                          _buildBottomNavBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClayButton(
              icon: Icons.menu_rounded,
              onTap: _toggleSidebar,
              inactiveColor: Colors.white,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.green300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Home',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green900,
                ),
              ),
            ),
            ClayButton(
              icon: Icons.notifications_rounded,
              onTap: () => _navigateToScreen(const NotificationScreen()),
              inactiveColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClayButton(
            icon: Icons.home_rounded,
            isActive: true, // Always active on Home
            onTap: () {}, // Already on Home
          ),
          ClayButton(
            icon: Icons.calendar_month_rounded,
            isActive: false,
            onTap: () => _navigateToScreen(const CalendarScreen()),
          ),

          // Floating Center Button (Diary)
          GestureDetector(
            onTap: () => _navigateToScreen(const DiaryListScreen()),
            child: Container(
              width: 56,
              height: 56,
              margin: const EdgeInsets.only(bottom: 30), // Float up
              decoration: BoxDecoration(
                color: AppColors.green400,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cream, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green400.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.book_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          ClayButton(
            icon: Icons.smart_toy_rounded,
            isActive: false,
            onTap: () => _navigateToScreen(const AIScreen()),
          ),
          ClayButton(
            icon: Icons.person_rounded,
            isActive: false,
            onTap: () => _navigateToScreen(const ProfileScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      color: AppColors.green50,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: _toggleSidebar,
                  color: AppColors.gray500,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSidebarItem(
              'Dashboard',
              Icons.home_rounded,
              null,
              onTap: _toggleSidebar,
            ),
            _buildSidebarItem(
              'Calendar',
              Icons.calendar_month_rounded,
              null,
              onTap: () => _navigateToSecondaryScreen(const CalendarScreen()),
            ),
            _buildSidebarItem(
              'Diary Entries',
              Icons.book_rounded,
              null,
              onTap: () => _navigateToSecondaryScreen(const DiaryListScreen()),
            ),
            _buildSidebarItem(
              'AI Coach',
              Icons.smart_toy_rounded,
              null,
              onTap: () => _navigateToSecondaryScreen(const AIScreen()),
            ),
            _buildSidebarItem(
              'Settings',
              Icons.settings_rounded,
              null,
              onTap: () => _navigateToSecondaryScreen(const ProfileScreen()),
            ),

            _buildSidebarItem(
              'Focus Timer',
              Icons.timer_rounded,
              null,
              onTap: () => _navigateToSecondaryScreen(const FocusScreen()),
            ),
            _buildSidebarItem(
              'Sticky Notes',
              Icons.note_alt_rounded,
              null,
              onTap: () =>
                  _navigateToSecondaryScreen(const StickyNotesScreen()),
            ),
            _buildSidebarItem(
              'Progress Report',
              Icons.bar_chart_rounded,
              null,
              onTap: () =>
                  _navigateToSecondaryScreen(const ProgressReportScreen()),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    String title,
    IconData icon,
    int? index, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.green50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.green600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
