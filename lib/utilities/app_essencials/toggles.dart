import 'package:flutter/material.dart';

class AppToggle extends StatelessWidget {
  final String firstOne;
  final String secondOne;
  final int selectedIndex;
  final Function(int) onToggle;

  const AppToggle({
    super.key,
    required this.firstOne,
    required this.secondOne,
    required this.selectedIndex,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          onToggle(1);
        } else if (details.primaryVelocity! > 0) {
          onToggle(0);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Theme.of(context).shadowColor.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(context, firstOne, 0),
            _buildToggleButton(context, secondOne, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, String text, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected ? [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected 
                  ? Theme.of(context).colorScheme.onPrimary 
                  : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}