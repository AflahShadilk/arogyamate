import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart'; 


class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}



// ignore: unused_element
Widget _buildDarkModeToggle(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
        icon: Icon(
          themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          color: themeProvider.themeMode == ThemeMode.dark ? Colors.yellow[600] : Colors.grey[800],
          size: 28,
        ),
        onPressed: () async {
          themeProvider.toggleTheme();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isDarkMode', themeProvider.themeMode == ThemeMode.dark);
        },
        
      ),
    ),
  );
}

