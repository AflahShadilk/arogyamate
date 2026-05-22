import 'dart:io';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final double? height;
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    this.title = "Managing Healthcare\nWith Excellence",
    this.subtitle = "Efficiency in Every Detail",
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<SessionController>(
      builder: (context, session, _) => GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bannerHeight = height ?? (constraints.maxWidth < 600 ? 170 : 220);
            return Container(
              height: bannerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    _BackgroundImage(
                      profileImage: session.profileImage,
                      primaryColor: theme.colorScheme.primary,
                    ),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.75),
                            theme.colorScheme.primary.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),

                    // Glassmorphism decorative circles
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      right: 40,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),

                    // Text content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                              letterSpacing: -0.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: Text(
                              subtitle,
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? profileImage;
  final Color primaryColor;

  const _BackgroundImage({
    required this.profileImage,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (profileImage != null && profileImage!.isNotEmpty) {
      return kIsWeb
          ? Image.network(profileImage!, fit: BoxFit.cover)
          : Image.file(File(profileImage!), fit: BoxFit.cover);
    }

    // Fallback: gradient background
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.local_hospital_rounded,
        size: 80,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }
}
