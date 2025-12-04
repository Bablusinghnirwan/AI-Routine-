import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/core/clay_widgets.dart';
import 'package:my_routine/features/notifications/notification_controller.dart';
import 'package:my_routine/features/notifications/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.gray700),
        title: Text(
          'Notifications 🔔',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<NotificationController>(
            builder: (context, controller, child) {
              if (controller.notifications.isEmpty) return const SizedBox();
              return PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.gray700,
                ),
                onSelected: (value) {
                  if (value == 'mark_read') {
                    controller.markAllAsRead();
                  } else if (value == 'clear_all') {
                    controller.clearAll();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'mark_read',
                    child: Text('Mark all as read'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'clear_all',
                    child: Text('Clear all'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          final notifications = controller.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.green200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      size: 64,
                      color: AppColors.green600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'All caught up!',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time to relax 🌿',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationItem(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NotificationController>(
      context,
      listen: false,
    );

    Color bgColor;
    Color iconColor;
    IconData iconData;

    switch (notification.type) {
      case NotificationType.reminder:
        bgColor = AppColors.orange100;
        iconColor = AppColors.orange500;
        iconData = Icons.alarm_rounded;
        break;
      case NotificationType.achievement:
        bgColor = AppColors.yellow100;
        iconColor = AppColors.yellow700;
        iconData = Icons.emoji_events_rounded;
        break;
      case NotificationType.ai:
        bgColor = AppColors.blue100;
        iconColor = AppColors.blue600;
        iconData = Icons.smart_toy_rounded;
        break;
      case NotificationType.update:
        bgColor = AppColors.purple100;
        iconColor = AppColors.purple600;
        iconData = Icons.campaign_rounded;
        break;
    }

    return GestureDetector(
      onTap: () => controller.markAsRead(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white.withOpacity(0.6)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: notification.isRead
              ? Border.all(color: Colors.transparent)
              : Border.all(color: iconColor.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, size: 24, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray800,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(notification.timestamp),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                    if (notification.actionLabel != null) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClayButton(
                          label: notification.actionLabel!,
                          icon: Icons.check_rounded,
                          onTap: () {
                            // Handle action
                            controller.markAsRead(notification);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${notification.actionLabel} done!',
                                ),
                              ),
                            );
                          },
                          isActive: true,
                          activeColor: bgColor,
                          iconColor: iconColor,
                          height: 36,
                          width: 120,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
