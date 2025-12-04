import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/auth/auth_controller.dart';
import 'package:my_routine/services/notification_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Settings State
  bool _dailyReminders = true;
  bool _habitAlerts = true;
  bool _quietMode = false;
  bool _cloudSync = true;
  TimeOfDay _dailySummaryTime = const TimeOfDay(hour: 20, minute: 0);
  double _fontSize = 1.0; // 0: Small, 1: Medium, 2: Large

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeManager = Provider.of<ThemeManager>(context);
    final user = authController.currentUser;
    final name = user?.userMetadata?['full_name'] ?? 'Achiever';

    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'Settings',
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 1. Profile Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.green200,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: AppColors.green600,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.blue500,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.gray700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClayButton(
                    label: "Edit Profile",
                    onTap: () {},
                    height: 36,
                    width: 120,
                    isActive: false,
                    icon: Icons.edit_note_rounded,
                    iconColor: AppColors.gray500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Appearance Settings
            _buildSectionHeader('Appearance'),
            ClayCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildThemeSelector(themeManager),
                  const Divider(height: 32),
                  _buildFontSizeSlider(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Notification Preferences
            _buildSectionHeader('Notifications'),
            ClayCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSwitch(
                    'Daily Reminders',
                    _dailyReminders,
                    (v) => setState(() => _dailyReminders = v),
                    Icons.calendar_today_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitch(
                    'Habit Alerts',
                    _habitAlerts,
                    (v) => setState(() => _habitAlerts = v),
                    Icons.check_circle_outline_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitch(
                    'Quiet Mode',
                    _quietMode,
                    (v) => setState(() => _quietMode = v),
                    Icons.do_not_disturb_on_rounded,
                  ),
                  const Divider(height: 32),
                  _buildTimePicker('Daily Summary Time', _dailySummaryTime),
                  const SizedBox(height: 16),
                  // Test Notification Button (Requested by user)
                  GestureDetector(
                    onTap: () async {
                      await NotificationService().showRoutineNotification(
                        "Test Notification",
                        "This is a test notification from Settings.",
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notification sent!')),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_rounded,
                          color: AppColors.blue500,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Test Notification",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blue600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Data & Privacy
            _buildSectionHeader('Data & Privacy'),
            ClayCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSwitch(
                    'Cloud Sync',
                    _cloudSync,
                    (v) => setState(() => _cloudSync = v),
                    Icons.cloud_sync_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildActionRow(
                    'Export Data (JSON)',
                    Icons.download_rounded,
                    () {},
                  ),
                  const SizedBox(height: 16),
                  _buildActionRow(
                    'Privacy Policy',
                    Icons.privacy_tip_rounded,
                    () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. General
            _buildSectionHeader('General'),
            ClayCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLanguageSelector(),
                  const SizedBox(height: 16),
                  _buildActionRow(
                    'Help Center',
                    Icons.help_outline_rounded,
                    () {},
                  ),
                  const Divider(height: 32),
                  _buildActionRow(
                    'Log Out',
                    Icons.logout_rounded,
                    () => authController.logout(),
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.gray600,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildThemeOption(
              themeManager,
              AppThemeMode.clay,
              Colors.green,
              'Default',
            ),
            _buildThemeOption(
              themeManager,
              AppThemeMode.dark,
              const Color(0xFF1A1A2E),
              'Dark Space',
            ),
            _buildThemeOption(
              themeManager,
              AppThemeMode.generated,
              Colors.pinkAccent,
              'Pink Sakura',
              isPink: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    ThemeManager manager,
    AppThemeMode mode,
    Color color,
    String label, {
    bool isPink = false,
  }) {
    final isSelected = isPink
        ? manager.customColors?.primaryColor == AppColors.pink500
        : manager.currentMode == mode && manager.customColors == null;

    return GestureDetector(
      onTap: () {
        if (isPink) {
          // Set Pink Theme manually for demo
          manager.setGeneratedTheme(
            CustomThemeColors(
              primaryColor: AppColors.pink500,
              bgColor: AppColors.pink50,
              cardColor: Colors.white,
              textColor: AppColors.gray800,
            ),
          );
        } else {
          manager.setTheme(mode);
        }
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.blue500, width: 3)
                  : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.blue600 : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Font Size',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
            ),
            Text(
              _fontSize == 0.0
                  ? 'Small'
                  : (_fontSize == 1.0 ? 'Medium' : 'Large'),
              style: GoogleFonts.nunito(fontSize: 14, color: AppColors.gray500),
            ),
          ],
        ),
        Slider(
          value: _fontSize,
          min: 0.0,
          max: 2.0,
          divisions: 2,
          activeColor: AppColors.green500,
          inactiveColor: AppColors.green100,
          onChanged: (val) => setState(() => _fontSize = val),
        ),
      ],
    );
  }

  Widget _buildSwitch(
    String label,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.green50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.green600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray700,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.green500,
          activeTrackColor: AppColors.green100,
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.blue50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            size: 20,
            color: AppColors.blue600,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray700,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              setState(() => _dailySummaryTime = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray300),
            ),
            child: Text(
              time.format(context),
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive ? AppColors.pink50 : AppColors.gray50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDestructive ? AppColors.pink500 : AppColors.gray600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDestructive ? AppColors.pink600 : AppColors.gray700,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.gray400),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.purple50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.language_rounded,
            size: 20,
            color: AppColors.purple500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Language',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gray700,
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: 'English',
            items: ['English', 'Hindi', 'Spanish']
                .map(
                  (l) => DropdownMenuItem(
                    value: l,
                    child: Text(
                      l,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppColors.gray700,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }
}
