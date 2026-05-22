import 'dart:io';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = doctor.imagePath != null && doctor.imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            _DoctorAvatar(
              imagePath: doctor.imagePath,
              hasImage: hasImage,
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor name
                  Text(
                    doctor.name ?? 'Unknown Doctor',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleLarge?.color,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Department row
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital_rounded,
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.department ?? 'General',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Tags row: qualification + timing
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (doctor.qualification != null &&
                          doctor.qualification!.isNotEmpty)
                        _InfoChip(
                          icon: Icons.school_rounded,
                          label: doctor.qualification!,
                          color: theme.colorScheme.primary,
                          theme: theme,
                        ),
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label:
                            '${doctor.startTime ?? 'N/A'} – ${doctor.endtime ?? ''}',
                        color: theme.colorScheme.primary,
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.primary.withOpacity(0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? imagePath;
  final bool hasImage;

  const _DoctorAvatar({
    required this.imagePath,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
        backgroundImage: hasImage
            ? (kIsWeb
                ? NetworkImage(imagePath!) as ImageProvider
                : FileImage(File(imagePath!)))
            : null,
        child: !hasImage
            ? Icon(
                Icons.person_rounded,
                size: 28,
                color: theme.colorScheme.primary.withOpacity(0.5),
              )
            : null,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ThemeData theme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
