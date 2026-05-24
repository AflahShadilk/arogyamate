import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PillToggleSwitch extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onToggle;

  const PillToggleSwitch({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Subtract 8 to account for the EdgeInsets.all(4) padding on left and right
        final itemWidth = (constraints.maxWidth - 8) / labels.length;

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0 &&
                selectedIndex < labels.length - 1) {
              onToggle(selectedIndex + 1);
            } else if (details.primaryVelocity! > 0 && selectedIndex > 0) {
              onToggle(selectedIndex - 1);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.06),
              ),
            ),
            child: Stack(
              children: [
                // Animated sliding pill
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  left: selectedIndex * itemWidth,
                  top: 0,
                  bottom: 0,
                  width: itemWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // Labels
                Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = index == selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onToggle(index),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.55) ??
                                      Colors.grey,
                              letterSpacing: 0.2,
                            ),
                            child: Text(labels[index]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
