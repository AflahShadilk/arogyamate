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

  Future<void> updateHospitalDetails({String? name, String? id, String? image}) async {
    await SessionManager.updateProfile(name: name, id: id, image: image);
    if (name != null) _hospitalName = name;
    if (id != null) _hospitalId = id;
    if (image != null) _profileImage = image;
    notifyListeners();
  }
}
