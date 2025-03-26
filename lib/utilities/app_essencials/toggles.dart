import 'package:flutter/material.dart';

GestureDetector Toggle(String firstOne, String secondOne, int selectedIndex, Function(int) onToggle) {
  return GestureDetector(
    onHorizontalDragEnd: (details) {
      if (details.primaryVelocity! < 0) {
        // Swipe Left → Select Second Option
        onToggle(1);
      } else if (details.primaryVelocity! > 0) {
        // Swipe Right → Select First Option
        onToggle(0);
      }
    },
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(firstOne, 0, selectedIndex, onToggle),
          _buildToggleButton(secondOne, 1, selectedIndex, onToggle),
        ],
      ),
    ),
  );
}

Widget _buildToggleButton(String text, int index, int selectedIndex, Function(int) onToggle) {
  bool isSelected = selectedIndex == index;
  return Expanded(
    child: GestureDetector(
      onTap: () => onToggle(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3770FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              // ignore: deprecated_member_use
              color: const Color(0xFF3770FF).withOpacity(0.25),
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
            color: isSelected ? Colors.white : const Color(0xFF757575),
            letterSpacing: 0.2,
          ),
        ),
      ),
    ),
  );
}