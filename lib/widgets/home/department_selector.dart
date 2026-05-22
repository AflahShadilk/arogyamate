import 'package:arogyamate/controllers/department_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class DepartmentSelector extends StatelessWidget {
  final String? selectedDepartment;
  final Function(String?) onDepartmentSelected;

  const DepartmentSelector({
    super.key,
    this.selectedDepartment,
    required this.onDepartmentSelected,
  });

  /// Map of department names to icons for medical categories.
  static const Map<String, IconData> _departmentIcons = {
    'cardiology': Icons.favorite_rounded,
    'neurology': Icons.psychology_rounded,
    'orthopedics': Icons.accessibility_new_rounded,
    'pediatrics': Icons.child_care_rounded,
    'dermatology': Icons.face_rounded,
    'ophthalmology': Icons.remove_red_eye_rounded,
    'ent': Icons.hearing_rounded,
    'gastroenterology': Icons.restaurant_rounded,
    'oncology': Icons.biotech_rounded,
    'pulmonology': Icons.air_rounded,
    'urology': Icons.water_drop_rounded,
    'gynecology': Icons.pregnant_woman_rounded,
    'psychiatry': Icons.self_improvement_rounded,
    'radiology': Icons.image_rounded,
    'general medicine': Icons.medical_services_rounded,
    'general surgery': Icons.local_hospital_rounded,
  };

  IconData _getIcon(String department) {
    final key = department.toLowerCase().trim();
    return _departmentIcons[key] ?? Icons.local_hospital_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<DepartmentController>(
      builder: (context, deptCtrl, _) {
        final departments = deptCtrl.departments;

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: departments.length + 1, // +1 for "All"
            itemBuilder: (context, index) {
              if (index == 0) {
                final isSelected = selectedDepartment == null;
                return _DepartmentChip(
                  label: 'All',
                  icon: Icons.grid_view_rounded,
                  isSelected: isSelected,
                  onTap: () => onDepartmentSelected(null),
                  theme: theme,
                );
              }

              final dept = departments[index - 1];
              final deptName = dept.department;
              final isSelected = selectedDepartment == deptName;

              return _DepartmentChip(
                label: deptName,
                icon: _getIcon(deptName),
                isSelected: isSelected,
                onTap: () => onDepartmentSelected(
                  isSelected ? null : deptName,
                ),
                theme: theme,
              );
            },
          ),
        );
      },
    );
  }
}

class _DepartmentChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _DepartmentChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 76,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : theme.colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
