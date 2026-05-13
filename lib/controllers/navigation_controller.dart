import 'package:flutter/foundation.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  int _addSectionIndex = 0;

  int get selectedIndex => _selectedIndex;
  int get addSectionIndex => _addSectionIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setAddSectionIndex(int index) {
    _addSectionIndex = index;
    notifyListeners();
  }
}
