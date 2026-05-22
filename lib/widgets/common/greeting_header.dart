import 'package:arogyamate/controllers/notification_controller.dart';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GreetingHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  final Widget? trailing;

  const GreetingHeader({
    super.key,
    this.onNotificationTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back,",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.55),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Consumer<SessionController>(
                builder: (context, session, _) => Text(
                  session.hospitalName ?? "ArogyaMate",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (trailing != null) ...[
          trailing!,
          const SizedBox(width: 8),
        ],

        _NotificationBell(onTap: onNotificationTap),
      ],
    );
  }
}

class _NotificationBell extends StatefulWidget {
  final VoidCallback? onTap;
  const _NotificationBell({this.onTap});

  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<_NotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  int _lastUnreadCount = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.08, end: 0.06), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: -0.04), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.04, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _maybeShake(int unread) {
    if (unread > 0 && unread != _lastUnreadCount) {
      _shakeController.forward(from: 0);
    }
    _lastUnreadCount = unread;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<NotificationController>(
      builder: (context, ctrl, _) {
        final unread = ctrl.unreadCount;
        _maybeShake(unread);

        return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) => Transform.rotate(
              angle: _shakeAnimation.value,
              child: child,
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  if (unread > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.cardColor,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
