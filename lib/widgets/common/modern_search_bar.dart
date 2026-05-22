import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onSearch;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onClearPressed;
  final bool showFilterButton;
  final bool showClearButton;

  const ModernSearchBar({
    super.key,
    this.hint = 'Search...',
    required this.controller,
    this.onSearch,
    this.onFilterPressed,
    this.onClearPressed,
    this.showFilterButton = true,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.08),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: theme.hintColor.withOpacity(0.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary.withOpacity(0.7),
              size: 22,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showFilterButton)
                _SuffixButton(
                  icon: Icons.tune_rounded,
                  color: theme.colorScheme.secondary,
                  onPressed: onFilterPressed,
                  tooltip: 'Filter',
                ),
              if (showClearButton)
                _SuffixButton(
                  icon: Icons.close_rounded,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  onPressed: () {
                    controller.clear();
                    onClearPressed?.call();
                    onSearch?.call('');
                  },
                  tooltip: 'Clear',
                ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}

class _SuffixButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final String tooltip;

  const _SuffixButton({
    required this.icon,
    required this.color,
    this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      onPressed: onPressed,
      tooltip: tooltip,
      splashRadius: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
