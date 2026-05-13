import 'package:arogyamate/core/session/session_manager.dart';
import 'package:flutter/foundation.dart';

class SessionController extends ChangeNotifier {
  String? _profileImage;
  String? _hospitalName;
  String? _hospitalId;

  String? get profileImage => _profileImage;
  String? get hospitalName => _hospitalName;
  String? get hospitalId => _hospitalId;

  Future<void> loadSessionData() async {
    _profileImage = await SessionManager.getProfileImage();
    _hospitalName = await SessionManager.getHospitalName();
    _hospitalId = await SessionManager.getHospitalId();
    notifyListeners();
  }

  void setProfileImage(String? path) {
    _profileImage = path;
    notifyListeners();
  }
}
