import 'package:arogyamate/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// A slide-down toast banner overlay that displays in-app notifications.
/// This should be placed in a [Stack] at the root of your navigation scaffold.
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     mainContent,
///     const InAppToastBanner(),
///   ],
/// )
/// ```
class InAppToastBanner extends StatelessWidget {
  const InAppToastBanner({super.key});

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

  Color _accentForType(String? type, ThemeData theme) {
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

    return Consumer<NotificationController>(
      builder: (context, notifyCtrl, _) {
        final accent = _accentForType(notifyCtrl.toastType, theme);

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          top: notifyCtrl.showToast ? 16 : -140,
          left: 16,
          right: 16,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => notifyCtrl.dismissToast(),
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! < 0) {
                  notifyCtrl.dismissToast();
                }
              },
              child: Material(
                elevation: 10,
                shadowColor: accent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(18),
                color: theme.cardColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: accent.withOpacity(0.25),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        theme.cardColor,
                        accent.withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _iconForType(notifyCtrl.toastType),
                          color: accent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Text content
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifyCtrl.toastTitle ?? 'Alert',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: theme.textTheme.titleMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notifyCtrl.toastMessage ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Close button
                      GestureDetector(
                        onTap: () => notifyCtrl.dismissToast(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
