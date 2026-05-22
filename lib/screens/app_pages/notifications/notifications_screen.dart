import 'package:arogyamate/controllers/notification_controller.dart';
import 'package:arogyamate/data_base/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().loadAll();
    });
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'doctor_leave':
        return Icons.beach_access_rounded;
      case 'appointment_cancelled':
        return Icons.cancel_outlined;
      case 'appointment_booked':
        return Icons.event_available_rounded;
      case 'appointment_updated':
        return Icons.edit_calendar_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _colorForType(String? type, ThemeData theme) {
    switch (type) {
      case 'doctor_leave':
        return Colors.orange;
      case 'appointment_cancelled':
        return Colors.redAccent;
      case 'appointment_booked':
        return theme.colorScheme.primary;
      case 'appointment_updated':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.cardColor,
        elevation: 0,
        actions: [
          Consumer<NotificationController>(
            builder: (context, ctrl, _) {
              if (ctrl.notifications.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Clear All',
                onPressed: () => _confirmClearAll(context, ctrl),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, ctrl, _) {
          final list = ctrl.notifications;
          // Sort latest first
          final sortedList = List<NotificationModel>.from(list)
            ..sort((a, b) {
              final aTime = a.dateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime = b.dateTime ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });

          if (sortedList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'All Caught Up!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No new alerts or notifications yet.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (ctrl.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ctrl.unreadCount} unread',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.done_all_rounded, size: 16),
                        label: Text(
                          'Mark all read',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => ctrl.markAllAsRead(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount: sortedList.length,
                  itemBuilder: (context, index) {
                    final item = sortedList[index];
                    final color = _colorForType(item.type, theme);
                    final formattedTime = item.dateTime != null
                        ? DateFormat('MMM d, h:mm a').format(item.dateTime!)
                        : '';

                    return Dismissible(
                      key: Key('notif_${item.key ?? index}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      onDismissed: (_) {
                        if (item.key != null) {
                          ctrl.deleteNotification(item.key as int);
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (!item.isRead && item.key != null) {
                            ctrl.markAsRead(item.key as int);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? theme.cardColor
                                : theme.colorScheme.primary.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item.isRead
                                  ? theme.colorScheme.outline.withOpacity(0.08)
                                  : theme.colorScheme.primary.withOpacity(0.15),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Type Indicator Icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _iconForType(item.type),
                                  color: color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title ?? 'Notification',
                                            style: GoogleFonts.poppins(
                                              fontWeight: item.isRead
                                                  ? FontWeight.w500
                                                  : FontWeight.w600,
                                              fontSize: 14,
                                              color: theme.textTheme.titleMedium?.color,
                                            ),
                                          ),
                                        ),
                                        if (!item.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.body ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formattedTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmClearAll(BuildContext context, NotificationController ctrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Notifications?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently delete all notifications from your local history.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              ctrl.clearAll();
              Navigator.pop(context);
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
