import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/auth/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State for toggles (Mock data for UI)
  bool _notificationsEnabled = true;
  bool _aiRoutineEnabled = true;
  bool _aiDailyFeedback = true;
  bool _aiMoodTracking = true;
  bool _cloudSyncEnabled = true;
  bool _autoRepeatTasks = true;
  bool _showStreakCount = true;

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'Settings ⚙️',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. General Settings
            _SettingsSection(
              title: 'General',
              icon: Icons.palette_rounded,
              color: AppColors.purple100,
              iconColor: AppColors.purple600,
              children: [
                const SizedBox(height: 12),
                _ThemeSelector(themeManager: themeManager),
                const SizedBox(height: 16),
                _SettingsTile(
                  label: 'Font Style',
                  trailing: _buildDropdown('Rounded Sans'),
                  icon: Icons.text_fields_rounded,
                ),
                _SettingsTile(
                  label: 'Text Size',
                  trailing: _buildDropdown('Medium'),
                  icon: Icons.format_size_rounded,
                ),
                _SettingsTile(
                  label: 'Language',
                  trailing: _buildDropdown('English'),
                  icon: Icons.language_rounded,
                ),
              ],
            ),

            // 2. Notifications
            _SettingsSection(
              title: 'Notifications',
              icon: Icons.notifications_rounded,
              color: AppColors.orange100,
              iconColor: AppColors.orange500,
              children: [
                _SettingsTile(
                  label: 'Task Reminders',
                  trailing: _buildSwitch(_notificationsEnabled, (v) {
                    setState(() => _notificationsEnabled = v);
                  }),
                  icon: Icons.check_circle_outline_rounded,
                ),
                _SettingsTile(
                  label: 'AI Routine Reminder',
                  trailing: _buildSwitch(true, (v) {}),
                  icon: Icons.smart_toy_outlined,
                ),
                _SettingsTile(
                  label: 'Reminder Lead Time',
                  trailing: _buildDropdown('10 min'),
                  icon: Icons.timer_rounded,
                ),
                _SettingsTile(
                  label: 'Quiet Hours',
                  trailing: Text(
                    '10 PM - 7 AM',
                    style: GoogleFonts.nunito(
                      color: AppColors.gray500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icons.nightlight_round,
                ),
              ],
            ),

            // 3. AI Routine Settings (Special Visuals)
            _SettingsSection(
              title: 'AI Routine Coach',
              icon: Icons.auto_awesome_rounded,
              color: AppColors.blue100,
              iconColor: AppColors.blue600,
              children: [
                _SettingsTile(
                  label: 'AI Routine Mode',
                  trailing: _buildSwitch(_aiRoutineEnabled, (v) {
                    setState(() => _aiRoutineEnabled = v);
                  }),
                  icon: Icons.psychology_rounded,
                ),
                if (_aiRoutineEnabled) ...[
                  _SettingsTile(
                    label: 'Daily Feedback',
                    trailing: _buildSwitch(_aiDailyFeedback, (v) {
                      setState(() => _aiDailyFeedback = v);
                    }),
                    icon: Icons.comment_rounded,
                  ),
                  _SettingsTile(
                    label: 'Mood Tracking',
                    trailing: _buildSwitch(_aiMoodTracking, (v) {
                      setState(() => _aiMoodTracking = v);
                    }),
                    icon: Icons.mood_rounded,
                  ),
                  _SettingsTile(
                    label: 'Coach Tone',
                    trailing: _buildDropdown('Friendly'),
                    icon: Icons.record_voice_over_rounded,
                  ),
                  const SizedBox(height: 16),
                  ClayButton(
                    icon: Icons.build_rounded,
                    label: "Rebuild My Routine",
                    onTap: () {},
                    isActive: true,
                    activeColor: AppColors.blue200,
                    iconColor: AppColors.blue700,
                  ),
                ],
              ],
            ),

            // 4. Sync & Backup
            _SettingsSection(
              title: 'Sync & Backup',
              icon: Icons.cloud_sync_rounded,
              color: AppColors.green100,
              iconColor: AppColors.green600,
              children: [
                _SettingsTile(
                  label: 'Cloud Sync',
                  trailing: _buildSwitch(_cloudSyncEnabled, (v) {
                    setState(() => _cloudSyncEnabled = v);
                  }),
                  icon: Icons.cloud_done_rounded,
                ),
                _SettingsTile(
                  label: 'Last Sync',
                  trailing: Text(
                    'Just now',
                    style: GoogleFonts.nunito(
                      color: AppColors.gray500,
                      fontSize: 12,
                    ),
                  ),
                  icon: Icons.access_time_rounded,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Export JSON'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.gray700,
                          side: const BorderSide(color: AppColors.gray300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload_rounded, size: 16),
                        label: const Text('Import JSON'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.gray700,
                          side: const BorderSide(color: AppColors.gray300),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 5. Account & Privacy
            _SettingsSection(
              title: 'Account',
              icon: Icons.person_rounded,
              color: AppColors.yellow100,
              iconColor: AppColors.yellow700,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.green200,
                    child: Text(
                      authController.currentUser?.email
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: GoogleFonts.fredoka(color: AppColors.green800),
                    ),
                  ),
                  title: Text(
                    authController.currentUser?.userMetadata?['full_name'] ??
                        'User',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    authController.currentUser?.email ?? 'No Email',
                    style: GoogleFonts.nunito(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    onPressed: () {},
                  ),
                ),
                const Divider(),
                _SettingsTile(
                  label: 'Change Password',
                  trailing: const Icon(Icons.chevron_right_rounded),
                  icon: Icons.lock_rounded,
                ),
                _SettingsTile(
                  label: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right_rounded),
                  icon: Icons.shield_rounded,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => authController.logout(),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.nunito(
                      color: AppColors.pink600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // 6. Task Defaults
            _SettingsSection(
              title: 'Task Defaults',
              icon: Icons.task_alt_rounded,
              color: AppColors.pink100,
              iconColor: AppColors.pink600,
              children: [
                _SettingsTile(
                  label: 'Default Reminder',
                  trailing: _buildDropdown('15 min'),
                  icon: Icons.alarm_rounded,
                ),
                _SettingsTile(
                  label: 'Auto-Repeat',
                  trailing: _buildSwitch(_autoRepeatTasks, (v) {
                    setState(() => _autoRepeatTasks = v);
                  }),
                  icon: Icons.repeat_rounded,
                ),
                _SettingsTile(
                  label: 'Show Streak',
                  trailing: _buildSwitch(_showStreakCount, (v) {
                    setState(() => _showStreakCount = v);
                  }),
                  icon: Icons.local_fire_department_rounded,
                ),
              ],
            ),

            // 7. App Data (Danger Zone)
            _SettingsSection(
              title: 'App Data',
              icon: Icons.storage_rounded,
              color: Colors.red.shade50,
              iconColor: Colors.red.shade400,
              children: [
                _SettingsTile(
                  label: 'Clear Cache',
                  trailing: const Icon(Icons.chevron_right_rounded),
                  icon: Icons.cleaning_services_rounded,
                ),
                const SizedBox(height: 8),
                ClayButton(
                  icon: Icons.delete_forever_rounded,
                  label: "Reset All Data",
                  onTap: () {},
                  isActive: true,
                  activeColor: Colors.red.shade100,
                  iconColor: Colors.red.shade600,
                ),
              ],
            ),

            // 8. Help & Support
            _SettingsSection(
              title: 'Help & Support',
              icon: Icons.help_outline_rounded,
              color: AppColors.blue50,
              iconColor: AppColors.blue500,
              children: [
                _SettingsTile(
                  label: 'How to Use',
                  trailing: const Icon(Icons.chevron_right_rounded),
                  icon: Icons.menu_book_rounded,
                ),
                _SettingsTile(
                  label: 'Send Feedback',
                  trailing: const Icon(Icons.chevron_right_rounded),
                  icon: Icons.chat_bubble_outline_rounded,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Version 1.0.0',
                    style: GoogleFonts.nunito(
                      color: AppColors.gray400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, Function(bool) onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.purple500,
      activeTrackColor: AppColors.purple100,
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.gray700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_drop_down_rounded,
            size: 16,
            color: AppColors.gray500,
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClayCard(
            color: Colors.white.withOpacity(0.8),
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final Widget trailing;
  final IconData icon;

  const _SettingsTile({
    required this.label,
    required this.trailing,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.gray400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeManager themeManager;

  const _ThemeSelector({required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _ThemeOption(
            color: AppColors.green100,
            label: 'Clay',
            isSelected: themeManager.currentMode == AppThemeMode.clay,
            onTap: () => themeManager.setTheme(AppThemeMode.clay),
          ),
          _ThemeOption(
            color: AppColors.purple100,
            label: 'Purple',
            isSelected: themeManager.currentMode == AppThemeMode.purpleNeo,
            onTap: () => themeManager.setTheme(AppThemeMode.purpleNeo),
          ),
          _ThemeOption(
            color: AppColors.orange100,
            label: 'Pastel',
            isSelected: themeManager.currentMode == AppThemeMode.cutePastel,
            onTap: () => themeManager.setTheme(AppThemeMode.cutePastel),
          ),
          _ThemeOption(
            color: Colors.white,
            label: 'Minimal',
            isSelected: themeManager.currentMode == AppThemeMode.minimalLight,
            onTap: () => themeManager.setTheme(AppThemeMode.minimalLight),
          ),
          if (themeManager.currentMode == AppThemeMode.generated &&
              themeManager.customColors != null)
            _ThemeOption(
              color: themeManager.customColors!.bgColor,
              label: 'AI Gen',
              isSelected: true,
              onTap: () {},
            ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple500 : Colors.transparent,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.purple500,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
