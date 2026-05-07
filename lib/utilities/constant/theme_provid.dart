import 'package:arogyamate/core/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  /// Toggles between light and dark and persists the choice via SessionManager.
  void toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await SessionManager.setDarkMode(_themeMode == ThemeMode.dark);
  }

  Future<void> _loadTheme() async {
    final isDark = await SessionManager.isDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

/// Reusable dark/light mode toggle icon button.
/// Usage: place anywhere a ThemeProvider is available via Provider.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      tooltip: themeProvider.isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: Icon(
        themeProvider.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: themeProvider.isDark ? Colors.yellow[600] : Colors.grey[800],
        size: 26,
      ),
      onPressed: () => themeProvider.toggleTheme(),
    );
  }
}
